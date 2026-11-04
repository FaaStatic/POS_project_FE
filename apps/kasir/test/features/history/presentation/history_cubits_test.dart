import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kasir/features/history/domain/usecases/history_usecases.dart';
import 'package:kasir/features/history/presentation/bloc/history_cubit.dart';

import '../../../helpers/fixtures.dart';
import '../../sync/domain/sync_usecases_test.dart' show queued;

void main() {
  late LocalFixture local;
  late MockTransactions remote;
  late MockDebts debts;
  setUp(() async {
    local = LocalFixture();
    debts = MockDebts();
    when(() => debts.listPayments(limit: any(named: 'limit'))).thenAnswer((_) async => const Ok([]));
    await local.seed();
    remote = MockTransactions();
  });
  tearDown(() => local.close());

  test('history lists unsent sales first', () async {
    await local.sales.add(queued('old-pending', at: DateTime(2026, 10, 24)));
    await local.sales.add(queued('new-synced', at: DateTime(2026, 10, 25)).copyWith(status: SaleStatus.synced));
    final cubit = HistoryCubit(WatchSales(local.sales), GetDebtPayments(debts), FakeNetwork())..start();
    final state = await cubit.stream.first;
    expect(state.sales.map((s) => s.clientRef), ['old-pending', 'new-synced']);
    await cubit.close();
  });

  test('payments made elsewhere join the debt history; this device\'s own are not listed twice', () async {
    final mine = Sale(
      clientRef: 'r1',
      receiptNumber: 'HTG-AAAA-1',
      createdAt: DateTime(2026, 10, 25),
      method: PaymentMethod.cash,
      cashierName: 'kasir1',
      total: 3000,
      lines: const [],
      kind: SaleKind.debtPayment,
      debtAfter: 0,
    );
    await local.sales.add(mine);
    when(() => debts.listPayments(limit: any(named: 'limit'))).thenAnswer((_) async => const Ok([
          DebtPaymentEntry(id: 'p1', debtId: 'd1', customerName: 'Bu Sri', amount: 3000, remaining: 0, paid: true, clientRef: 'HTG-AAAA-1'),
          DebtPaymentEntry(id: 'p2', debtId: 'd2', customerName: 'Pak Budi', amount: 1000, remaining: 500, paid: false, cashier: 'admin'),
        ]));
    final network = FakeNetwork();
    final cubit = HistoryCubit(WatchSales(local.sales), GetDebtPayments(debts), network)..start();
    final state = await cubit.stream.firstWhere((s) => s.payments.isNotEmpty && s.sales.isNotEmpty);
    expect(state.otherPayments.map((p) => p.id), ['p2']);

    // Offline the server is not asked and the last copy stays.
    network.online = false;
    clearInteractions(debts);
    when(() => debts.listPayments(limit: any(named: 'limit'))).thenAnswer((_) async => const Err(NetworkFailure()));
    await cubit.refreshPayments();
    verifyNever(() => debts.listPayments(limit: any(named: 'limit'), customerId: any(named: 'customerId')));
    expect(cubit.state.payments, hasLength(2));
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
