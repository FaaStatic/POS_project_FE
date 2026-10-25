import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/history/domain/usecases/history_usecases.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../sync/domain/sync_usecases_test.dart' show queued;

void main() {
  late LocalFixture local;
  late MockTransactions remote;

  setUp(() async {
    local = LocalFixture();
    await local.seed();
    remote = MockTransactions();
  });
  tearDown(() => local.close());

  CancelSale cancel() => CancelSale(local.sales, CancelTransaction(remote), local.cache);

  test('unsynced sale is cancelled locally and stock returns', () async {
    await local.sales.add(queued('a'));
    expect(await cancel()((await local.sales.byRef('a'))!, 'salah input'), isA<Ok<void>>());
    expect((await local.sales.byRef('a'))!.status, SaleStatus.cancelled);
    expect((await local.cache.product('p1'))!.stock, 11);
    verifyNever(() => remote.cancel(any(), any()));
    expect(await local.sales.pending(), isEmpty);
  });

  test('synced sale is cancelled on the server first', () async {
    await local.sales.add(queued('a').copyWith(status: SaleStatus.synced, transactionId: 't1'));
    when(() => remote.cancel('t1', 'salah input')).thenAnswer((_) async => const Ok(null));
    expect(await cancel()((await local.sales.byRef('a'))!, ' salah input '), isA<Ok<void>>());
    expect((await local.sales.byRef('a'))!.cancelReason, 'salah input');
  });

  test('server refusal leaves the sale untouched', () async {
    final sale = queued('a').copyWith(status: SaleStatus.synced, transactionId: 't1');
    await local.sales.add(sale);
    when(() => remote.cancel('t1', any())).thenAnswer((_) async => const Err(ForbiddenFailure('only today')));
    expect(await cancel()(sale, 'salah input'), const Err<void>(ForbiddenFailure('only today')));
    expect((await local.sales.byRef('a'))!.status, SaleStatus.synced);
  });

  test('reason is required; already cancelled is a no-op; synced without id fails', () async {
    final sale = queued('a');
    expect(await cancel()(sale, 'x'), const Err<void>(ValidationFailure('reason_length')));
    expect(await cancel()(sale.copyWith(status: SaleStatus.cancelled), 'alasan'), isA<Ok<void>>());
    expect(await cancel()(sale.copyWith(status: SaleStatus.synced), 'alasan'), const Err<void>(NotFoundFailure()));
  });

  test('watch and get read the local log', () async {
    await local.sales.add(queued('a'));
    expect((await WatchSales(local.sales)().first).single.clientRef, 'a');
    expect((await GetSale(local.sales)('a'))?.total, 3500);
  });
}
