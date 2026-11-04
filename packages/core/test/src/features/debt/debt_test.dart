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
    final page = (await GetDebts(repo)(const DebtQuery(unpaidOnly: true, oldestFirst: true, limit: 5)) as Ok<Paged<Debt>>).value;
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

  test('unpaid list walks every page; payment history maps the register receipt number', () async {
    var calls = 0;
    adapter.on('GET', ApiPaths.debts, (o) {
      calls++;
      return FakeReply(200, envelope({'has_next': calls == 1, 'after_id': 'd1', 'after_time': '2026-10-25T08:00:00Z', 'transaction_list': [debtJson()]}));
    });
    expect((await repo.listUnpaid() as Ok<List<Debt>>).value, hasLength(2));
    expect(adapter.requests.every((r) => r.queryParameters['status'] == 0), isTrue);

    adapter.on('GET', ApiPaths.debtPayments, (_) => FakeReply(200, envelope({
          'has_next': false,
          'payment_list': [
            {'id': 'p1', 'debt_id': 'd1', 'customer_name': 'Bu Sri', 'nominal_bayar': 3000, 'remaining_debt': 0, 'status': 'Lunas', 'cashier': 'kasir1', 'client_ref': 'HTG-AAAA-1', 'paid_at': '2026-10-25T08:00:00Z'},
            {'id': 'p2', 'debt_id': 'd1', 'customer_name': 'Bu Sri', 'nominal_bayar': 1000, 'remaining_debt': 3000, 'status': 'Belum Lunas', 'cashier': 'admin', 'paid_at': '2026-10-24T08:00:00Z'},
          ],
        })));
    final payments = (await GetDebtPayments(repo)(limit: 20) as Ok<List<DebtPaymentEntry>>).value;
    expect(payments.map((p) => (p.clientRef, p.paid, p.amount)), [('HTG-AAAA-1', true, 3000), ('', false, 1000)]);
    expect(adapter.requests.last.queryParameters, {'limit': 20});

    await GetDebtPayments(repo)(customerId: 'k1');
    expect(adapter.requests.last.queryParameters, {'limit': 50, 'customer_id': 'k1'});
  });

  test('receipt and monthly recap return the server pdf path', () async {
    adapter
      ..on('GET', ApiPaths.debtPaymentReceipt('p1'), (_) => FakeReply(200, envelope({'id': 'p1', 'url_pdf': '/api/v1/insight/reports/struk.pdf'})))
      ..on('GET', ApiPaths.debtPaymentsReport, (_) => FakeReply(200, envelope({'count': 3, 'url_pdf': '/api/v1/insight/reports/rekap.pdf'})));
    expect((await GetDebtPaymentReceiptPdf(repo)('p1') as Ok<String>).value, '/api/v1/insight/reports/struk.pdf');
    expect((await GetDebtPaymentsRecapPdf(repo)(11, 2026) as Ok<String>).value, '/api/v1/insight/reports/rekap.pdf');
    expect(adapter.requests.last.queryParameters, {'month': 11, 'year': 2026});
  });

  test('manual add', () async {
    adapter.on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    expect(await AddManualDebt(repo)(customerId: 'k1', amount: 10000, dueDate: DateTime(2026, 11, 1)), isA<Ok<void>>());
    expect(adapter.requests.last.data, {'customer_id': 'k1', 'total_transaksi': 10000, 'jatuh_tempo': '2026-11-01'});
    expect(await AddManualDebt(repo)(customerId: 'k1', amount: 0), isA<Err<void>>());
  });

  test('manual add sends the trimmed note and leaves a blank one out', () async {
    adapter.on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    await AddManualDebt(repo)(customerId: 'k1', amount: 5000, note: '  Pinjam tunai ');
    expect(adapter.requests.last.data, {'customer_id': 'k1', 'total_transaksi': 5000, 'note': 'Pinjam tunai'});
    await AddManualDebt(repo)(customerId: 'k1', amount: 5000, note: '   ');
    expect(adapter.requests.last.data, {'customer_id': 'k1', 'total_transaksi': 5000});
  });
}
