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
  late FakeNetwork network;
  var scheduled = 0;

  setUpAll(registerFallbacks);
  setUp(() {
    local = LocalFixture();
    remote = MockTransactions();
    final products = MockProducts(), categories = MockCategories(), customers = MockCustomers();
    when(products.listAll).thenAnswer((_) async => const Ok([]));
    when(categories.list).thenAnswer((_) async => const Ok([]));
    when(customers.listAll).thenAnswer((_) async => const Ok([]));
    refresh = RefreshCatalog(products, categories, customers, local.cache);
    network = FakeNetwork(false);
    scheduled = 0;
    when(() => remote.sync(any())).thenAnswer((inv) async => Ok([
          for (final s in inv.positionalArguments.single as List<OfflineSale>)
            SyncResult(clientRef: s.clientRef, status: SyncStatus.created, invoice: 'INV'),
        ]));
  });
  tearDown(() => local.close());

  SyncCubit build() => SyncCubit(
        sync: SyncPendingTransactions(local.sales, remote, refresh),
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
