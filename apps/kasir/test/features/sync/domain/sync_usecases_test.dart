import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/sync/domain/usecases/sync_usecases.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

Sale queued(String ref, {DateTime? at}) => Sale(
      clientRef: ref,
      receiptNumber: 'OFF-AAAA-1',
      createdAt: at ?? DateTime(2026, 10, 25, 9),
      method: PaymentMethod.cash,
      cashierName: 'kasir1',
      total: 3500,
      lines: const [SaleLine(productId: 'p1', name: 'Indomie', qty: 1, unitPrice: 3500)],
    );

void main() {
  late LocalFixture local;
  late MockTransactions remote;
  late RefreshCatalog refresh;
  late MockProducts products;

  setUpAll(registerFallbacks);

  setUp(() async {
    local = LocalFixture();
    remote = MockTransactions();
    products = MockProducts();
    final categories = MockCategories();
    final customers = MockCustomers();
    when(products.listAll).thenAnswer((_) async => const Ok([]));
    when(categories.list).thenAnswer((_) async => const Ok([]));
    when(customers.listAll).thenAnswer((_) async => const Ok([]));
    refresh = RefreshCatalog(products, categories, customers, local.cache);
  });
  tearDown(() => local.close());

  SyncPendingTransactions sync() => SyncPendingTransactions(local.sales, remote, refresh);

  test('accepted items take the invoice; failures keep their reason per item', () async {
    await local.sales.add(queued('a', at: DateTime(2026, 10, 25, 8)));
    await local.sales.add(queued('b'));
    await local.sales.add(queued('c'));
    when(() => remote.sync(any())).thenAnswer((_) async => const Ok([
          SyncResult(clientRef: 'a', status: SyncStatus.created, transactionId: 't1', invoice: 'INV-1', stockConflict: true),
          SyncResult(clientRef: 'b', status: SyncStatus.duplicate, transactionId: 't2', invoice: 'INV-2'),
          SyncResult(clientRef: 'c', status: SyncStatus.failed, error: 'product deleted'),
        ]));
    final report = (await sync()() as Ok<SyncReport>).value;
    expect([report.synced, report.failed, report.conflicts, report.remaining], [2, 1, 1, 0]);
    expect((await local.sales.byRef('a'))!.receiptNumber, 'INV-1');
    expect((await local.sales.byRef('a'))!.stockConflict, isTrue);
    expect((await local.sales.byRef('c'))!.status, SaleStatus.failed);
    expect((await local.sales.byRef('c'))!.error, 'product deleted');
    final sent = verify(() => remote.sync(captureAny())).captured.single as List<OfflineSale>;
    expect(sent.map((s) => s.clientRef), ['a', 'b', 'c']);
    verify(products.listAll).called(1);
  });

  test('retryable failures stay queued', () async {
    await local.sales.add(queued('a'));
    when(() => remote.sync(any())).thenAnswer((_) async =>
        const Ok([SyncResult(clientRef: 'a', status: SyncStatus.failed, retryable: true, error: 'db busy')]));
    final report = (await sync()() as Ok<SyncReport>).value;
    expect(report.remaining, 1);
    expect((await local.sales.byRef('a'))!.error, 'db busy');
    verifyNever(products.listAll);
  });

  test('a missing result is treated as retryable', () async {
    await local.sales.add(queued('a'));
    when(() => remote.sync(any())).thenAnswer((_) async => const Ok([]));
    expect((await sync()() as Ok<SyncReport>).value.remaining, 1);
  });

  test('network failure before anything synced is surfaced', () async {
    await local.sales.add(queued('a'));
    when(() => remote.sync(any())).thenAnswer((_) async => const Err(NetworkFailure()));
    expect(await sync()(), const Err<SyncReport>(NetworkFailure()));
    expect(await local.sales.pending(), hasLength(1));
  });

  test('nothing queued means no request', () async {
    expect((await sync()() as Ok<SyncReport>).value.synced, 0);
    verifyNever(() => remote.sync(any()));
  });

  test('more than 100 sales are sent in batches', () async {
    for (var i = 0; i < 150; i++) {
      await local.sales.add(queued('s$i', at: DateTime(2026, 10, 25).add(Duration(seconds: i))));
    }
    when(() => remote.sync(any())).thenAnswer((inv) async => Ok([
          for (final s in inv.positionalArguments.single as List<OfflineSale>)
            SyncResult(clientRef: s.clientRef, status: SyncStatus.created, invoice: 'INV-${s.clientRef}'),
        ]));
    final report = (await sync()() as Ok<SyncReport>).value;
    expect(report.synced, 150);
    final batches = verify(() => remote.sync(captureAny())).captured.cast<List<OfflineSale>>();
    expect(batches.map((b) => b.length), [100, 50]);
  });

  test('next slot is noon, then midnight', () {
    expect(nextSyncSlot(DateTime(2026, 10, 25, 9)), DateTime(2026, 10, 25, 12));
    expect(nextSyncSlot(DateTime(2026, 10, 25, 12)), DateTime(2026, 10, 26));
    expect(nextSyncSlot(DateTime(2026, 10, 31, 23, 59)), DateTime(2026, 11, 1));
  });
}
