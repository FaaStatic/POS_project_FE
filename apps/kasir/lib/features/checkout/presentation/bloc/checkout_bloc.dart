import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/checkout_usecases.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

export 'checkout_event.dart';
export 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({
    required this.drafts,
    required this.network,
    required this.openDraft,
    required this.closeDraft,
    required this.addItem,
    required this.scan,
    required this.purge,
    required this.checkout,
    required this.startCharge,
    required this.resolveCharge,
    required this.shortfalls,
    this.pollInterval = const Duration(seconds: 5),
  }) : super(const CheckoutState(loading: true)) {
    on<CheckoutStarted>(_started);
    on<DraftsChanged>(_draftsChanged);
    on<NetworkChanged>((e, emit) => emit(state.copyWith(online: e.online)));
    on<TabSelected>(_tabSelected);
    on<NewTabRequested>(_newTab);
    on<TabClosed>(_tabClosed);
    on<ProductAdded>(_productAdded);
    on<BarcodeSubmitted>(_barcode);
    on<QtyChanged>((e, emit) => _whenOpen(emit, () => drafts.setQty(e.itemId, e.qty)));
    on<ItemRemoved>((e, emit) => _whenOpen(emit, () => drafts.removeItem(e.itemId)));
    on<DestinationChanged>((e, emit) => _whenOpen(emit, () => drafts.setDestination(e.itemId, e.destination)));
    on<CustomerChanged>(_customer);
    on<MethodChanged>((e, emit) => emit(state.copyWith(method: e.method)));
    on<VaBankChanged>((e, emit) => emit(state.copyWith(vaBank: e.bank)));
    on<PayRequested>(_pay);
    on<ChargesPolled>(_poll);
  }

  final DraftRepository drafts;
  final NetworkStatus network;
  final OpenDraft openDraft;
  final CloseDraft closeDraft;
  final AddItem addItem;
  final ScanBarcode scan;
  final PurgeStaleDrafts purge;
  final CheckoutTransaction checkout;
  final StartCharge startCharge;
  final ResolveCharge resolveCharge;
  final FindStockShortfalls shortfalls;
  final Duration pollInterval;

  StreamSubscription<List<Draft>>? _draftSub;
  StreamSubscription<bool>? _netSub;
  Timer? _poller;

  // Bloc handlers run concurrently; overlapping polls could record one charge twice.
  bool _polling = false;

  CheckoutState _notify(CheckoutState s, CheckoutNotice notice) => s.copyWith(notice: notice, noticeId: s.noticeId + 1);

  Future<void> _started(CheckoutStarted e, Emitter<CheckoutState> emit) async {
    final removed = await purge();
    final online = await network.isOnline();
    var next = state.copyWith(online: online);
    if (removed > 0) next = _notify(next, StaleDraftsNotice(removed));
    emit(next);
    _draftSub = drafts.watchAll().listen((list) => add(DraftsChanged(list)));
    _netSub = network.watch().listen((online) => add(NetworkChanged(online)));
    _poller = Timer.periodic(pollInterval, (_) {
      if (state.drafts.any((d) => d.status == DraftStatus.awaitingPayment)) add(const ChargesPolled());
    });
  }

  Future<void> _draftsChanged(DraftsChanged e, Emitter<CheckoutState> emit) async {
    if (e.drafts.isEmpty) {
      // Always keep one tab ready for the next buyer.
      final created = await openDraft();
      emit(state.copyWith(activeId: created.id, loading: false));
      return;
    }
    final activeId = e.drafts.any((d) => d.id == state.activeId) ? state.activeId : _fallback(e.drafts)?.id;
    final active = e.drafts.where((d) => d.id == activeId).firstOrNull;
    emit(
      state.copyWith(
        drafts: e.drafts,
        activeId: activeId,
        loading: false,
        shortfalls: active == null ? const {} : await shortfalls(active),
      ),
    );
  }

  Draft? _fallback(List<Draft> list) => list.where((d) => d.status == DraftStatus.open).firstOrNull ?? list.firstOrNull;

  Future<void> _tabSelected(TabSelected e, Emitter<CheckoutState> emit) async {
    final draft = state.drafts.where((d) => d.id == e.draftId).firstOrNull;
    if (draft == null) return;
    emit(state.copyWith(activeId: draft.id, shortfalls: await shortfalls(draft)));
    if (draft.status == DraftStatus.awaitingPayment) add(ChargesPolled(orderId: draft.charge?.orderId));
  }

  Future<void> _newTab(NewTabRequested e, Emitter<CheckoutState> emit) async {
    final created = await openDraft();
    emit(state.copyWith(activeId: created.id, shortfalls: const {}, method: PaymentMethod.cash));
  }

  Future<void> _tabClosed(TabClosed e, Emitter<CheckoutState> emit) async {
    final draft = state.drafts.where((d) => d.id == e.draftId).firstOrNull;
    if (draft == null) return;
    final result = await closeDraft(draft);
    if (result case Err(:final failure)) {
      emit(_notify(state, FailureNotice(failure)));
      return;
    }
    final remaining = state.drafts.where((d) => d.id != draft.id).toList();
    emit(state.copyWith(activeId: _fallback(remaining)?.id));
  }

  Future<void> _productAdded(ProductAdded e, Emitter<CheckoutState> emit) async {
    final draft = state.active;
    if (draft == null) return;
    if (await addItem(draft, e.product) case Err()) emit(_notify(state, const TabLockedNotice()));
  }

  Future<void> _barcode(BarcodeSubmitted e, Emitter<CheckoutState> emit) async {
    final draft = state.active;
    if (draft == null || e.code.trim().isEmpty) return;
    final outcome = await scan(draft, e.code);
    emit(
      _notify(state, switch (outcome) {
        ScanAdded(:final product) => ScanAddedNotice(product.name, draft.number),
        ScanUnknown(:final code) => ScanUnknownNotice(code),
        ScanLocked() => const TabLockedNotice(),
      }),
    );
  }

  Future<void> _whenOpen(Emitter<CheckoutState> emit, Future<void> Function() change) async {
    if (state.active?.isLocked ?? true) {
      emit(_notify(state, const TabLockedNotice()));
      return;
    }
    await change();
  }

  Future<void> _customer(CustomerChanged e, Emitter<CheckoutState> emit) async {
    final draft = state.active;
    if (draft == null) return;
    await drafts.setCustomer(draft.id, id: e.id, name: e.name);
  }

  Future<void> _pay(PayRequested e, Emitter<CheckoutState> emit) async {
    final draft = state.active;
    if (draft == null || state.paying) return;
    emit(state.copyWith(paying: true));
    switch (state.method) {
      case PaymentMethod.cash || PaymentMethod.debt:
        final result = await checkout(draft, state.method);
        emit(switch (result) {
          Ok(:final value) => _notify(
            state.copyWith(paying: false, method: PaymentMethod.cash),
            SaleRecordedNotice(value.sale, offline: value.offline),
          ),
          Err(:final failure) => _notify(state.copyWith(paying: false), FailureNotice(failure)),
        });
      case PaymentMethod.qris || PaymentMethod.va:
        final result = await startCharge(
          draft,
          state.method == PaymentMethod.qris ? ChargeMethod.qris : ChargeMethod.va,
          bank: e.bank,
        );
        emit(switch (result) {
          Ok() => state.copyWith(paying: false),
          Err(:final failure) => _notify(state.copyWith(paying: false), FailureNotice(failure)),
        });
    }
  }

  Future<void> _poll(ChargesPolled e, Emitter<CheckoutState> emit) async {
    if (_polling) return;
    _polling = true;
    try {
      await _resolveWaiting(e, emit);
    } finally {
      _polling = false;
    }
  }

  Future<void> _resolveWaiting(ChargesPolled e, Emitter<CheckoutState> emit) async {
    final waiting = state.drafts.where(
      (d) => d.status == DraftStatus.awaitingPayment && (e.orderId == null || d.charge?.orderId == e.orderId),
    );
    for (final draft in waiting) {
      switch (await resolveCharge(draft)) {
        case ChargeResolution.paid:
          emit(_notify(state, ChargePaidNotice(draft.number)));
        case ChargeResolution.failed:
          emit(_notify(state, ChargeFailedNotice(draft.number)));
        case ChargeResolution.pending:
          break;
      }
    }
  }

  @override
  Future<void> close() async {
    _poller?.cancel();
    await _draftSub?.cancel();
    await _netSub?.cancel();
    return super.close();
  }
}
