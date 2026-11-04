import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/sync/domain/usecases/sync_usecases.dart';
import 'package:kasir/features/sync/presentation/bloc/sync_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../domain/sync_usecases_test.dart' show queued;

void main() {
  late LocalFixture local;
  late MockTransactions remote;
  late RefreshCatalog refresh;
  late MockProducts products;
  late MockDebts debts;
  late MockAuth auth;
  late FakeNetwork network;
  var scheduled = 0;

  setUpAll(registerFallbacks);
  setUp(() {
    local = LocalFixture();
    remote = MockTransactions();
    products = MockProducts();
    final categories = MockCategories(), customers = MockCustomers();
    debts = MockDebts();
    auth = MockAuth();
    when(() => auth.current).thenReturn(staff);
    when(products.listAll).thenAnswer((_) async => const Ok([]));
    when(categories.list).thenAnswer((_) async => const Ok([]));
    when(customers.listAll).thenAnswer((_) async => const Ok([]));
    when(debts.listUnpaid).thenAnswer((_) async => const Ok([]));
    refresh = RefreshCatalog(products, categories, customers, debts, local.cache);
    network = FakeNetwork(false);
    scheduled = 0;
    when(() => remote.sync(any())).thenAnswer((inv) async => Ok([
          for (final s in inv.positionalArguments.single as List<OfflineSale>)
            SyncResult(clientRef: s.clientRef, status: SyncStatus.created, invoice: 'INV'),
        ]));
  });
  tearDown(() => local.close());

  SyncCubit build() => SyncCubit(
        sync: SyncPendingTransactions(local.sales, remote, debts, GetCurrentSession(auth), refresh),
        refreshCatalog: refresh,
        sales: local.sales,
        network: network,
        scheduleNext: () async => scheduled++,
      );

  Future<void> pump() => Future<void>.delayed(const Duration(milliseconds: 30));

  test('offline start counts pending and schedules the next slot', () async {
    await local.sales.add(queued('a'));
    final cubit = build();
    await cubit.start();
    await pump();
    expect(cubit.state.online, isFalse);
    expect(cubit.state.pending, 1);
    expect(scheduled, 1);
    verifyNever(() => remote.sync(any()));
    await cubit.close();
  });

  test('regaining connection syncs automatically', () async {
    await local.sales.add(queued('a'));
    final cubit = build();
    await cubit.start();
    network.set(true);
    await pump();
    expect(cubit.state.pending, 0);
    expect(cubit.state.online, isTrue);
    await cubit.close();
  });

  test('coming back to the app pulls the catalog once, not again within the gap', () async {
    final cubit = build();
    await cubit.refreshOnResume();
    await cubit.refreshOnResume();
    verify(products.listAll).called(1);
    await cubit.close();
  });

  test('coming back to the app does not pull while sales wait to be sent', () async {
    when(() => remote.sync(any())).thenAnswer((_) async => const Err(NetworkFailure()));
    await local.sales.add(queued('a'));
    final cubit = build();
    await cubit.start();
    network.set(true);
    await pump();
    expect(cubit.state, isA<SyncState>().having((s) => s.pending, 'pending', 1).having((s) => s.online, 'online', true));
    await cubit.refreshOnResume();
    verifyNever(products.listAll);
    await cubit.close();
  });

  test('manual sync reports the count; a failure is surfaced', () async {
    await local.sales.add(queued('a'));
    final cubit = build();
    await cubit.syncNow();
    expect(cubit.state.lastReport?.synced, 1);
    expect(cubit.state.reportId, 1);
    await local.sales.add(queued('b'));
    when(() => remote.sync(any())).thenAnswer((_) async => const Err(NetworkFailure()));
    await cubit.syncNow();
    expect(cubit.state.failure, const NetworkFailure());
    await cubit.close();
  });

  test('a refresh asked by the person re-reads the catalog even when no sale was sent', () async {
    final cubit = build();
    await cubit.syncNow(quiet: true);
    verifyNever(products.listAll);
    await cubit.syncNow(quiet: true, pullCatalog: true);
    verify(products.listAll).called(1);
    await cubit.close();
  });

  test('online start sends queued debt payments before it pulls the catalog, so the old debt is not shown again', () async {
    network.online = true;
    await local.sales.add(Sale(
      clientRef: 'd1',
      receiptNumber: 'HTG-AAAA-1',
      createdAt: DateTime(2026, 10, 25, 9),
      method: PaymentMethod.cash,
      customerId: 'k1',
      cashierName: 'kasir1',
      total: 3000,
      lines: const [],
      kind: SaleKind.debtPayment,
      debtId: 'debt1',
    ));
    when(() => debts.pay(debtId: any(named: 'debtId'), userId: any(named: 'userId'), amount: any(named: 'amount'), idempotencyKey: any(named: 'idempotencyKey')))
        .thenAnswer((_) async => const Ok(DebtPaymentReceipt(debtId: 'debt1', customerName: 'Bu Sri', amount: 3000, previousRemaining: 5000, remaining: 2000, paid: false)));
    final cubit = build();
    await cubit.start();
    verifyInOrder([
      () => debts.pay(debtId: 'debt1', userId: 'u1', amount: 3000, idempotencyKey: 'HTG-AAAA-1'),
      debts.listUnpaid,
    ]);
    // Sending already pulled the catalog once; start does not pull it a second time.
    verifyNever(debts.listUnpaid);
    await cubit.close();
  });

  test('online start refreshes the catalog and sends the queue quietly', () async {
    network.online = true;
    await local.sales.add(queued('a'));
    final cubit = build();
    await cubit.start();
    await pump();
    expect(cubit.state.pending, 0);
    expect(cubit.state.lastReport?.synced, 1);
    await cubit.close();
  });
}
