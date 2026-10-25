import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> customerJson(String id, {String name = 'Bu Sri', List<Map<String, dynamic>> debts = const []}) =>
    {'id': id, 'nama': name, 'no_hp': '0812', 'alamat': 'Jl. Melati', 'active': true, 'debts': debts};

Map<String, dynamic> debtJson({String status = 'Belum Lunas', int remaining = 5000}) => {
      'debt_id': 'd1',
      'status': status,
      'customer_id': 'k1',
      'name_customer': 'Bu Sri',
      'total_debt': 8000,
      'remaining_debt': remaining,
      'date_debt': '2026-10-01',
    };

void main() {
  late FakeAdapter adapter;
  late CustomerRepositoryImpl repo;

  setUp(() {
    adapter = FakeAdapter();
    repo = CustomerRepositoryImpl(CustomerRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('get maps Indonesian keys and debts', () async {
    adapter.on('GET', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(customerJson('k1', debts: [debtJson()]))));
    final c = (await GetCustomer(repo)('k1') as Ok<Customer>).value;
    expect(c.name, 'Bu Sri');
    expect(c.phone, '0812');
    expect(c.outstandingDebt, 5000);
    expect(c.hasActiveDebt, isTrue);
    expect(c.debts.single.paidAmount, 3000);
  });

  test('create posts then finds the new customer by name', () async {
    adapter
      ..on('POST', ApiPaths.customers, (_) => FakeReply(201, envelope(null)))
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({
            'has_next': false,
            'customer_lists': [customerJson('k2', name: 'Pak Budi'), customerJson('k1')],
          })));
    final c = (await CreateCustomer(repo)(const CustomerInput(name: ' Bu Sri ', phone: '0812')) as Ok<Customer>).value;
    expect(c.id, 'k1');
    expect(adapter.requests.first.data, {'customer_name': 'Bu Sri', 'phone_number': '0812'});
    expect(adapter.requests.last.queryParameters['order'], 'desc');
    expect(await CreateCustomer(repo)(const CustomerInput(name: ' ')), const Err<Customer>(ValidationFailure('required')));
  });

  test('listAll pages, inactive filter, update, lifecycle', () async {
    adapter
      ..on('GET', ApiPaths.customers, (o) => FakeReply(200, envelope({
            'has_next': o.queryParameters['after_id'] == null,
            'after_id': 'k1',
            'after_time': 't',
            'customer_lists': [customerJson(o.queryParameters['after_id'] == null ? 'k1' : 'k2')],
          })))
      ..on('PUT', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(null)))
      ..on('POST', ApiPaths.customerRestore('k1'), (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.customerPurge('k1'), (_) => FakeReply(200, envelope({'mode': 'anonymized'})));
    expect((await GetAllCustomers(repo)() as Ok<List<Customer>>).value.map((c) => c.id), ['k1', 'k2']);
    await GetCustomers(repo)(const CustomerQuery(inactive: true));
    expect(adapter.requests.last.queryParameters['status'], 'inactive');
    expect(await UpdateCustomer(repo)('k1', const CustomerInput(name: 'Bu Sri')), isA<Ok<void>>());
    expect(await UpdateCustomer(repo)('k1', const CustomerInput(name: '')), isA<Err<void>>());
    expect(await DeactivateCustomer(repo)('k1'), isA<Ok<void>>());
    expect(await RestoreCustomer(repo)('k1'), isA<Ok<void>>());
    expect(await PurgeCustomer(repo)(const Customer(id: 'k1', name: 'Bu Sri')), const Ok(PurgeMode.anonymized));
  });

  test('purge is refused locally while a debt is active', () async {
    final c = Customer(id: 'k1', name: 'Bu Sri', debts: [debtFromJson(debtJson())]);
    expect(await PurgeCustomer(repo)(c), const Err<PurgeMode>(ConflictFailure('customer_has_debt')));
  });
}
