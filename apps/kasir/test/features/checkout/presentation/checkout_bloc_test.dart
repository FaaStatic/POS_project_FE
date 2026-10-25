import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/checkout/domain/usecases/checkout_usecases.dart';
import 'package:kasir/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  late LocalFixture local;
  late MockTransactions remote;
  late MockPayments payments;
  late MockAuth auth;
  late FakeNetwork network;

  setUpAll(registerFallbacks);

  setUp(() async {
    local = LocalFixture();
    await local.seed();
    remote = MockTransactions();
    payments = MockPayments();
    auth = MockAuth();
    network = FakeNetwork(false);
    when(() => auth.current).thenReturn(staff);
  });
  tearDown(() => local.close());

  CheckoutBloc build() {
    final session = GetCurrentSession(auth);
    final add = AddItem(local.drafts);
    return CheckoutBloc(
      drafts: local.drafts,
      network: network,
      openDraft: OpenDraft(local.drafts),
      closeDraft: CloseDraft(local.drafts),
      addItem: add,
      scan: ScanBarcode(local.cache, add),
      purge: PurgeStaleDrafts(local.drafts),
      checkout: CheckoutTransaction(
          transactions: remote, sales: local.sales, drafts: local.drafts, cache: local.cache, network: network, session: session),
      startCharge: StartCharge(qris: ChargeQris(payments), va: ChargeVa(payments), drafts: local.drafts, network: network, session: session),
      resolveCharge: ResolveCharge(
          status: CheckPaymentStatus(payments), transactions: remote, sales: local.sales, drafts: local.drafts, cache: local.cache, session: session),
      shortfalls: FindStockShortfalls(local.cache),
      pollInterval: const Duration(hours: 1),
    );
  }

  Future<CheckoutBloc> started() async {
    final bloc = build()..add(const CheckoutStarted());
    await bloc.stream.firstWhere((s) => s.drafts.isNotEmpty);
    return bloc;
  }

  Future<CheckoutState> settle(CheckoutBloc bloc) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return bloc.state;
  }

  test('start opens Transaksi 1 when there are no tabs', () async {
    final bloc = await started();
    expect(bloc.state.drafts.single.number, 1);
    expect(bloc.state.active?.number, 1);
    expect(bloc.state.online, isFalse);
    await bloc.close();
  });

  test('start reports stale drafts removed', () async {
    final bloc = build();
    final notices = bloc.stream.map((s) => s.notice).where((n) => n != null);
    await local.db.into(local.db.draftCarts).insert(
          staleDraft(),
        );
    bloc.add(const CheckoutStarted());
    expect(await notices.first, isA<StaleDraftsNotice>().having((n) => n.count, 'count', 1));
    await bloc.close();
  });

  test('scan adds to the active tab and names it; unknown codes are reported', () async {
    final bloc = await started();
    bloc.add(const BarcodeSubmitted('899'));
    var s = await settle(bloc);
    expect(s.notice, isA<ScanAddedNotice>().having((n) => n.tabNumber, 'tab', 1));
    expect(s.active!.items.single.name, 'Indomie Goreng');
    bloc.add(const BarcodeSubmitted('123'));
    s = await settle(bloc);
    expect(s.notice, isA<ScanUnknownNotice>().having((n) => n.code, 'code', '123'));
    await bloc.close();
  });

  test('parallel tabs: pay Transaksi 2 offline, Transaksi 1 keeps its cart', () async {
    final bloc = await started();
    bloc.add(const ProductAdded(aqua));
    await settle(bloc);
    final first = bloc.state.activeId!;
    bloc.add(const NewTabRequested());
    await settle(bloc);
    expect(bloc.state.active!.number, 2);
    bloc.add(const ProductAdded(indomie));
    await settle(bloc);
    bloc.add(const PayRequested());
    final s = await settle(bloc);
    expect(s.notice, isA<SaleRecordedNotice>().having((n) => n.offline, 'offline', isTrue));
    expect(s.activeId, first);
    expect(s.active!.items.single.name, 'Aqua 600ml');
    expect(await local.sales.pending(), hasLength(1));
    await bloc.close();
  });

  test('closing the last tab opens a fresh Transaksi 1', () async {
    final bloc = await started();
    bloc.add(TabClosed(bloc.state.activeId!));
    final s = await bloc.stream.firstWhere((s) => s.drafts.isNotEmpty && s.drafts.single.isEmpty);
    expect(s.drafts.single.number, 1);
    await bloc.close();
  });

  test('qty, removal, destination and customer edit the active tab', () async {
    final bloc = await started();
    bloc.add(const ProductAdded(indomie));
    bloc.add(const ProductAdded(pulsa));
    var s = await settle(bloc);
    final items = s.active!.items;
    bloc.add(QtyChanged(items[0].id, 5));
    bloc.add(DestinationChanged(items[1].id, '0812'));
    bloc.add(const CustomerChanged(id: 'k1', name: 'Bu Sri'));
    s = await settle(bloc);
    expect(s.active!.items[0].qty, 5);
    expect(s.active!.items[1].destination, '0812');
    expect(s.active!.customerName, 'Bu Sri');
    bloc.add(ItemRemoved(items[1].id));
    s = await settle(bloc);
    expect(s.active!.items, hasLength(1));
    await bloc.close();
  });

  test('stock shortfall appears for the active tab', () async {
    final bloc = await started();
    bloc.add(const ProductAdded(aqua));
    bloc.add(const ProductAdded(aqua));
    final s = await settle(bloc);
    expect(s.shortfalls, {'p2': 1.0});
    await bloc.close();
  });

  test('QRIS offline fails with a network notice; online locks the tab, then paid on poll', () async {
    final bloc = await started();
    bloc.add(const ProductAdded(indomie));
    bloc.add(const MethodChanged(PaymentMethod.qris));
    await settle(bloc);
    bloc.add(const PayRequested());
    var s = await settle(bloc);
    expect(s.notice, isA<FailureNotice>().having((n) => n.failure, 'failure', const NetworkFailure()));

    network.online = true;
    const charge = Charge(orderId: 'ORD-1', method: ChargeMethod.qris, state: PaymentState.pending, grossAmount: 3535);
    when(() => payments.chargeQris(userId: 'u1', customerId: null, items: any(named: 'items'))).thenAnswer((_) async => const Ok(charge));
    bloc.add(const PayRequested());
    s = await settle(bloc);
    expect(s.active!.status, DraftStatus.awaitingPayment);

    bloc.add(const ProductAdded(aqua));
    s = await settle(bloc);
    expect(s.notice, isA<TabLockedNotice>());

    when(() => payments.status('ORD-1')).thenAnswer((_) async =>
        const Ok(ChargeStatus(orderId: 'ORD-1', state: PaymentState.success, grossAmount: 3535, transactionId: 't1')));
    when(() => remote.get('t1')).thenAnswer((_) async => const Ok(Transaction(id: 't1', invoice: 'INV-1', method: PaymentMethod.qris, total: 3535)));
    bloc.add(const ChargesPolled(orderId: 'ORD-1'));
    s = await settle(bloc);
    expect(s.notice, isA<ChargePaidNotice>());
    expect(s.active!.status, DraftStatus.paid);
    await bloc.close();
  });

  test('expired charge reopens the tab with a notice; waiting tab cannot be closed', () async {
    network.online = true;
    final bloc = await started();
    bloc.add(const ProductAdded(indomie));
    await settle(bloc);
    await local.drafts.markAwaiting(bloc.state.activeId!, const Charge(orderId: 'O', method: ChargeMethod.va, state: PaymentState.pending, grossAmount: 1));
    var s = await settle(bloc);
    bloc.add(TabClosed(s.activeId!));
    s = await settle(bloc);
    expect(s.notice, isA<FailureNotice>());
    when(() => payments.status('O')).thenAnswer((_) async => const Ok(ChargeStatus(orderId: 'O', state: PaymentState.expired, grossAmount: 1)));
    bloc.add(TabSelected(s.activeId!));
    s = await settle(bloc);
    expect(s.notice, isA<ChargeFailedNotice>());
    expect(s.active!.status, DraftStatus.open);
    await bloc.close();
  });

  blocTest<CheckoutBloc, CheckoutState>(
    'network and method changes update state',
    build: build,
    act: (b) => b
      ..add(const NetworkChanged(true))
      ..add(const MethodChanged(PaymentMethod.debt)),
    expect: () => [
      isA<CheckoutState>().having((s) => s.online, 'online', true),
      isA<CheckoutState>().having((s) => s.method, 'method', PaymentMethod.debt),
    ],
  );

  test('debt without customer is refused with a validation notice', () async {
    final bloc = await started();
    bloc.add(const ProductAdded(indomie));
    bloc.add(const MethodChanged(PaymentMethod.debt));
    await settle(bloc);
    bloc.add(const PayRequested());
    final s = await settle(bloc);
    expect(s.notice, isA<FailureNotice>().having((n) => n.failure, 'f', const ValidationFailure('debt_needs_customer')));
    await bloc.close();
  });
}

DraftCartsCompanion staleDraft() {
  final old = DateTime.now().subtract(const Duration(days: 2));
  return DraftCartsCompanion.insert(number: 1, createdAt: old, updatedAt: old);
}
