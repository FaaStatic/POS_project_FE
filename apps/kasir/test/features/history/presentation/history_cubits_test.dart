import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/history/domain/usecases/history_usecases.dart';
import 'package:kasir/features/history/presentation/bloc/history_cubit.dart';

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

  test('history lists unsent sales first', () async {
    await local.sales.add(queued('old-pending', at: DateTime(2026, 10, 24)));
    await local.sales.add(queued('new-synced', at: DateTime(2026, 10, 25)).copyWith(status: SaleStatus.synced));
    final cubit = HistoryCubit(WatchSales(local.sales))..start();
    final state = await cubit.stream.first;
    expect(state.sales.map((s) => s.clientRef), ['old-pending', 'new-synced']);
    await cubit.close();
  });

  test('detail loads, cancels with reason, and prints', () async {
    await local.sales.add(queued('a'));
    final printer = _CountingPrinter();
    final settings = ReceiptSettingsRepositoryImpl(local.store);
    await settings.save(const ReceiptSettings(printerAddress: 'AA'));
    final cubit = SaleDetailCubit(GetSale(local.sales), CancelSale(local.sales, CancelTransaction(remote), local.cache), PrintReceipt(printer, settings));
    await cubit.load('a');
    expect(cubit.state.sale?.clientRef, 'a');
    await cubit.cancel('x');
    expect(cubit.state.failure, const ValidationFailure('reason_length'));
    await cubit.cancel('salah input');
    expect(cubit.state.cancelled, isTrue);
    expect(cubit.state.sale?.status, SaleStatus.cancelled);
    await cubit.print(ReceiptDocument(const []));
    expect(cubit.state.printed, isTrue);
    expect(printer.count, 1);
  });

  test('print failure is reported', () async {
    await local.sales.add(queued('a'));
    final cubit = SaleDetailCubit(GetSale(local.sales), CancelSale(local.sales, CancelTransaction(remote), local.cache),
        PrintReceipt(_CountingPrinter(), ReceiptSettingsRepositoryImpl(local.store)));
    await cubit.load('a');
    await cubit.print(ReceiptDocument(const []));
    expect(cubit.state.failure, const ValidationFailure('no_printer'));
  });
}

class _CountingPrinter implements ReceiptPrinter {
  int count = 0;
  @override
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings) async {
    count++;
    return const Ok(null);
  }
}
