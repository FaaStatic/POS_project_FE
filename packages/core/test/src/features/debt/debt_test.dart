import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

import '../customer/customer_test.dart' show debtJson;

void main() {
  late FakeAdapter adapter;
  late DebtRepositoryImpl repo;
  final debt = debtFromJson(debtJson());

  setUp(() {
    adapter = FakeAdapter();
    repo = DebtRepositoryImpl(DebtRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('list sends unpaid/oldest filters and maps transaction_list', () async {
    adapter.on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({'has_next': false, 'transaction_list': [debtJson()]})));
    final page = (await GetDebts(repo)(const DebtQuery(unpaidOnly: true, oldestFirst: true, limit: 5)) as Ok<Page<Debt>>).value;
    expect(page.items.single.paid, isFalse);
    expect(adapter.requests.single.queryParameters, {'status': 0, 'order': 'asc', 'limit': 5});
  });

  test('pay validates amount and sends idempotency key', () async {
    adapter.on('POST', ApiPaths.debtPay, (_) => FakeReply(200, envelope({
          'debt_id': 'd1',
          'customer_name': 'Bu Sri',
          'nominal_bayar': 5000,
          'previous_remaining_debt': 5000,
          'remaining_debt': 0,
          'total_debt': 8000,
          'status': 'Lunas',
          'paid_at': '2026-10-25T08:00:00Z',
        })));
    final pay = PayDebt(repo);
    expect(await pay(debt: debt, userId: 'u1', amount: 0, idempotencyKey: 'k'), const Err<DebtPaymentReceipt>(ValidationFailure('positive_number')));
    expect(await pay(debt: debt, userId: 'u1', amount: 6000, idempotencyKey: 'k'), const Err<DebtPaymentReceipt>(ValidationFailure('exceeds_remaining')));
    final r = (await pay(debt: debt, userId: 'u1', amount: 5000, idempotencyKey: 'k1') as Ok<DebtPaymentReceipt>).value;
    expect(r.paid, isTrue);
    expect(adapter.requests.single.data, {'debt_id': 'd1', 'user_id': 'u1', 'nominal_bayar': 5000, 'idempotency_key': 'k1'});
  });

  test('get and manual add', () async {
    adapter
      ..on('GET', ApiPaths.debt('d1'), (_) => FakeReply(200, envelope(debtJson(status: 'Lunas', remaining: 0))))
      ..on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    expect((await GetDebt(repo)('d1') as Ok<Debt>).value.paid, isTrue);
    expect(await AddManualDebt(repo)(customerId: 'k1', amount: 10000, dueDate: DateTime(2026, 11, 1)), isA<Ok<void>>());
    expect(adapter.requests.last.data, {'customer_id': 'k1', 'total_transaksi': 10000, 'jatuh_tempo': '2026-11-01'});
    expect(await AddManualDebt(repo)(customerId: 'k1', amount: 0), isA<Err<void>>());
  });
}
