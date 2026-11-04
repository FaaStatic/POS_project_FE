import 'package:cms/features/customers/presentation/bloc/customers_cubit.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/cms_harness.dart';

class MockCustomers extends Mock implements CustomerRepository {}

class MockTransactions extends Mock implements TransactionRepository {}

class MockDebts extends Mock implements DebtRepository {}

class MockReports extends Mock implements ReportRepository {}

Map<String, dynamic> customerJson(String id) =>
    {'id': id, 'nama': 'Bu Sri', 'no_hp': '0812', 'alamat': 'Jl. Melati', 'active': true};

void main() {
  setUpAll(() {
    registerFallbackValue(const CustomerQuery());
    registerFallbackValue(const DebtQuery());
    registerFallbackValue(const CustomerInput(name: ''));
  });

  test('cubit actions and detail', () async {
    final repo = MockCustomers();
    final trx = MockTransactions();
    const c = Customer(id: 'k1', name: 'Bu Sri');
    when(() => repo.list(any(), after: any(named: 'after'))).thenAnswer((_) async => const Ok(Paged(items: [c])));
    when(() => repo.create(any())).thenAnswer((_) async => const Ok(c));
    when(() => repo.update('k1', any())).thenAnswer((_) async => const Ok(null));
    when(() => repo.deactivate('k1')).thenAnswer((_) async => const Ok(null));
    when(() => repo.restore('k1')).thenAnswer((_) async => const Ok(null));
    when(() => repo.purge('k1')).thenAnswer((_) async => const Ok(PurgeMode.deleted));
    final cubit = CustomersCubit(GetCustomers(repo), CreateCustomer(repo), UpdateCustomer(repo), DeactivateCustomer(repo), RestoreCustomer(repo), PurgeCustomer(repo));
    cubit.showInactive(true);
    await Future<void>.delayed(Duration.zero);
    cubit.search('sri');
    await Future<void>.delayed(Duration.zero);
    expect(cubit.query.inactive, isTrue);
    expect(await cubit.create(const CustomerInput(name: 'Bu Sri')), const Ok(c));
    expect(await cubit.update(c, const CustomerInput(name: 'Bu Sri')), isA<Ok<void>>());
    expect(await cubit.deactivate(c), isA<Ok<void>>());
    expect(await cubit.restore(c), isA<Ok<void>>());
    expect(await cubit.purge(c), const Ok(PurgeMode.deleted));

    when(() => repo.get('k1')).thenAnswer((_) async => const Ok(c));
    when(() => trx.listByCustomer('k1', after: any(named: 'after')))
        .thenAnswer((_) async => const Ok(Paged(items: [Transaction(id: 't', invoice: 'INV', method: PaymentMethod.cash, total: 1)])));
    final debts = MockDebts();
    when(() => debts.listPayments(limit: any(named: 'limit'), customerId: any(named: 'customerId')))
        .thenAnswer((_) async => const Ok([DebtPaymentEntry(id: 'p1', debtId: 'd1', customerName: 'Bu Sri', amount: 3000, remaining: 5000, paid: false, cashier: 'kasir1')]));
    when(() => debts.list(any(), after: any(named: 'after'))).thenAnswer((_) async => const Ok(Paged(items: [
          Debt(id: 'd1', customerId: 'k1', customerName: 'Bu Sri', total: 8000, remaining: 5000, paid: false),
        ])));
    when(() => debts.add(customerId: 'k1', amount: 2000, dueDate: null, note: 'Pinjam tunai')).thenAnswer((_) async => const Ok(null));
    final detail = CustomerDetailCubit(
      GetCustomer(repo),
      GetCustomerTransactions(trx),
      GetDebts(debts),
      AddManualDebt(debts),
      GetDebtPayments(debts),
      GetDebtPaymentReceiptPdf(debts),
      DownloadReport(MockReports()),
    );
    await detail.load('k1');
    expect(detail.state.transactions.single.invoice, 'INV');
    expect(detail.state.openDebt?.remaining, 5000);
    expect(detail.state.payments.single.cashier, 'kasir1');
    expect(await detail.addDebt('k1', 2000, null, 'Pinjam tunai'), isA<Ok<void>>());
    verify(() => debts.add(customerId: 'k1', amount: 2000, dueDate: null, note: 'Pinjam tunai')).called(1);
    verify(() => repo.get('k1')).called(2);
    when(() => repo.get('k1')).thenAnswer((_) async => const Err(NotFoundFailure('gone')));
    await detail.load('k1');
    expect(detail.state.failure, const NotFoundFailure('gone'));
  });

  testWidgets('customers page: add, purge refused with active debt, open detail', (tester) async {
    final app = CmsHarness();
    final debt = {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000};
    app.adapter
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'customer_lists': [customerJson('k1')]})))
      ..on('POST', ApiPaths.customers, (_) => FakeReply(201, envelope(null)))
      ..on('DELETE', ApiPaths.customerPurge('k1'), (_) => FakeReply(409, errorBody('customer still has an unpaid debt; settle it first')))
      ..on('GET', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(customerJson('k1'))))
      ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({'transaction_list': [debt]})))
      ..on('GET', ApiPaths.customerTransactions('k1'), (_) => FakeReply(200, envelope({'list_transaction': []})));
    await app.pump(tester, location: '/customers');
    expect(find.text('Bu Sri'), findsOneWidget);

    await tester.tap(find.widgetWithText(ShadButton, 'Tambah pelanggan'));
    await tester.pumpAndSettle();
    await tester.enterText(formFields.first, 'Bu Sri');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan.'), findsOneWidget);
    await dismissInfo(tester);

    await tester.tap(find.byTooltip('Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus permanen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ShadButton, 'Hapus permanen'));
    await tester.pumpAndSettle();
    expect(find.text('Pelanggan masih punya hutang aktif, tidak bisa dihapus permanen.'), findsOneWidget);
    await dismissInfo(tester);

    await tester.tap(find.text('Bu Sri'));
    await tester.pumpAndSettle();
    expect(find.text('Belum lunas'), findsOneWidget);
    expect(find.text('Belum ada transaksi.'), findsOneWidget);
  });

  testWidgets('customer detail: the open debt shows, and more credit can be added to it', (tester) async {
    final app = CmsHarness();
    final debt = {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000};
    app.adapter
      ..on('GET', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(customerJson('k1'))))
      ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({'transaction_list': [debt]})))
      ..on('GET', ApiPaths.customerTransactions('k1'), (_) => FakeReply(200, envelope({'list_transaction': []})))
      ..on('GET', ApiPaths.debtPayments, (_) => FakeReply(200, envelope({'has_next': false, 'payment_list': [
            {'id': 'p1', 'debt_id': 'd1', 'customer_name': 'Bu Sri', 'nominal_bayar': 3000, 'remaining_debt': 5000, 'status': 'Belum Lunas', 'cashier': 'kasir1', 'paid_at': '2026-10-25T08:00:00Z'},
            {'id': 'p2', 'debt_id': 'd1', 'customer_name': 'Bu Sri', 'nominal_bayar': 1000, 'remaining_debt': 8000, 'status': 'Belum Lunas', 'cashier': '', 'paid_at': '2026-10-24T08:00:00Z'},
          ]})))
      ..on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    await app.pump(tester, location: '/customers/k1');
    expect(app.adapter.requests.firstWhere((r) => r.method == 'GET' && r.path == ApiPaths.debts).queryParameters, containsPair('customer_id', 'k1'));
    expect(find.text('Belum lunas'), findsWidgets);
    expect(app.adapter.requests.firstWhere((r) => r.path == ApiPaths.debtPayments).queryParameters, containsPair('customer_id', 'k1'));
    // Payments sit above the transactions: who took them (or CMS), and a receipt per row.
    expect(find.text('Kasir: kasir1'), findsOneWidget);
    expect(find.text('Kasir: CMS'), findsOneWidget);
    expect(find.byTooltip('Unduh struk pembayaran'), findsNWidgets(2));
    expect(tester.getTopLeft(find.text('Pembayaran hutang')).dy, lessThan(tester.getTopLeft(find.text('Transaksi').last).dy));

    await tester.tap(find.byTooltip('Tambah hutang'));
    await tester.pumpAndSettle();
    expect(find.text('Hutang saat ini'), findsOneWidget);
    await tester.enterText(find.descendant(of: find.byType(ShadDialog), matching: find.byType(EditableText)).first, '2000');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.lastWhere((r) => r.method == 'POST' && r.path == ApiPaths.debts).data,
        {'customer_id': 'k1', 'total_transaksi': 2000});
    // The page reloads its debt after saving.
    expect(app.adapter.requests.where((r) => r.method == 'GET' && r.path == ApiPaths.debts), hasLength(2));
  });
}
