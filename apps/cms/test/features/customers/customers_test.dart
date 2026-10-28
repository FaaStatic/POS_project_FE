import 'package:cms/features/customers/presentation/bloc/customers_cubit.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/cms_harness.dart';

class MockCustomers extends Mock implements CustomerRepository {}

class MockTransactions extends Mock implements TransactionRepository {}

Map<String, dynamic> customerJson(String id, {List<Map<String, dynamic>> debts = const []}) =>
    {'id': id, 'nama': 'Bu Sri', 'no_hp': '0812', 'alamat': 'Jl. Melati', 'active': true, 'debts': debts};

void main() {
  setUpAll(() {
    registerFallbackValue(const CustomerQuery());
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
    final detail = CustomerDetailCubit(GetCustomer(repo), GetCustomerTransactions(trx));
    await detail.load('k1');
    expect(detail.state.transactions.single.invoice, 'INV');
    when(() => repo.get('k1')).thenAnswer((_) async => const Err(NotFoundFailure('gone')));
    await detail.load('k1');
    expect(detail.state.failure, const NotFoundFailure('gone'));
  });

  testWidgets('customers page: add, purge refused with active debt, open detail', (tester) async {
    final app = CmsHarness();
    final debt = {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000};
    app.adapter
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'customer_lists': [customerJson('k1', debts: [debt])]})))
      ..on('POST', ApiPaths.customers, (_) => FakeReply(201, envelope(null)))
      ..on('GET', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(customerJson('k1', debts: [debt]))))
      ..on('GET', ApiPaths.customerTransactions('k1'), (_) => FakeReply(200, envelope({'list_transaction': []})));
    await app.pump(tester, location: '/customers');
    expect(find.text('Bu Sri'), findsOneWidget);

    await tester.tap(find.widgetWithText(ShadButton, 'Tambah customer'));
    await tester.pumpAndSettle();
    await tester.enterText(formFields.first, 'Bu Sri');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ShadButton, 'Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus permanen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ShadButton, 'Hapus permanen'));
    await tester.pumpAndSettle();
    expect(find.text('Customer masih punya hutang aktif, tidak bisa dihapus permanen.'), findsOneWidget);

    await tester.tap(find.text('Bu Sri'));
    await tester.pumpAndSettle();
    expect(find.text('Belum lunas'), findsOneWidget);
    expect(find.text('Belum ada transaksi.'), findsOneWidget);
  });
}
