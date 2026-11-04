import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/history_usecases.dart';

part 'history_cubit.freezed.dart';

@freezed
abstract class HistoryState with _$HistoryState {
  const HistoryState._();

  const factory HistoryState({
    @Default(true) bool loading,
    @Default([]) List<Sale> sales,

    /// The server's newest debt payments (any register, or the CMS), as last fetched.
    @Default([]) List<DebtPaymentEntry> payments,
  }) = _HistoryState;

  /// Payments made on this device are already in [sales] under their receipt number.
  List<DebtPaymentEntry> get otherPayments {
    final mine = {for (final s in sales) s.receiptNumber};
    return [for (final p in payments) if (p.clientRef.isEmpty || !mine.contains(p.clientRef)) p];
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._watch, this._payments, this._network) : super(const HistoryState());
  final WatchSales _watch;
  final GetDebtPayments _payments;
  final NetworkStatus _network;
  StreamSubscription<List<Sale>>? _sub;

  void start() {
    _sub = _watch().listen((sales) {
      // Unsent sales first so the cashier sees what still needs a connection.
      final sorted = [...sales]
        ..sort((a, b) {
          final pa = a.status == SaleStatus.pending || a.status == SaleStatus.failed ? 0 : 1;
          final pb = b.status == SaleStatus.pending || b.status == SaleStatus.failed ? 0 : 1;
          return pa != pb ? pa - pb : b.createdAt.compareTo(a.createdAt);
        });
      if (!state.loading && listEquals(state.sales, sorted)) return;
      emit(state.copyWith(loading: false, sales: sorted));
    });
    refreshPayments();
  }

  /// Reads the server's payment history; offline or on an error the last copy stays.
  Future<void> refreshPayments() async {
    if (!await _network.isOnline()) return;
    if (await _payments() case Ok(:final value) when !isClosed && !listEquals(value, state.payments)) {
      emit(state.copyWith(payments: value));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

@freezed
abstract class SaleDetailState with _$SaleDetailState {
  const factory SaleDetailState({
    @Default(true) bool loading,
    Sale? sale,
    @Default(false) bool working,
    Failure? failure,
    @Default(false) bool cancelled,
    @Default(false) bool printed,
    @Default(0) int eventId,
  }) = _SaleDetailState;
}

class SaleDetailCubit extends Cubit<SaleDetailState> {
  SaleDetailCubit(this._get, this._cancel, this._print) : super(const SaleDetailState());
  final GetSale _get;
  final CancelSale _cancel;
  final PrintReceipt _print;

  Future<void> load(String ref) async => emit(SaleDetailState(loading: false, sale: await _get(ref)));

  Future<void> cancel(String reason) async {
    final sale = state.sale;
    if (sale == null || state.working) return;
    emit(state.copyWith(working: true, failure: null));
    final result = await _cancel(sale, reason);
    final fresh = await _get(sale.clientRef);
    emit(switch (result) {
      Ok() => state.copyWith(working: false, sale: fresh, cancelled: true, eventId: state.eventId + 1),
      Err(:final failure) => state.copyWith(working: false, failure: failure, eventId: state.eventId + 1),
    });
  }

  /// The page builds [document] because receipt labels are translated.
  Future<void> print(ReceiptDocument document) async {
    if (state.sale == null || state.working) return;
    emit(state.copyWith(working: true, failure: null, printed: false));
    final result = await _print(document);
    emit(switch (result) {
      Ok() => state.copyWith(working: false, printed: true, eventId: state.eventId + 1),
      Err(:final failure) => state.copyWith(working: false, failure: failure, eventId: state.eventId + 1),
    });
  }
}
