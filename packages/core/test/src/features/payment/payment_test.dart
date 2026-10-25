import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAdapter adapter;
  late PaymentRepositoryImpl repo;
  const items = [ChargeItem('p1', 2)];

  setUp(() {
    adapter = FakeAdapter();
    repo = PaymentRepositoryImpl(PaymentRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('QRIS charge maps qr fields', () async {
    adapter.on('POST', ApiPaths.paymentQris, (_) => FakeReply(201, envelope({
          'order_id': 'ORD-1',
          'method': 'qris',
          'status': 'pending',
          'gross_amount': 7070,
          'qr_string': '000201',
          'qr_url': 'https://qr.test/1.png',
          'expiry_time': '2026-10-25T08:15:00Z',
        })));
    final c = (await ChargeQris(repo)(userId: 'u1', items: items) as Ok<Charge>).value;
    expect(c.state, PaymentState.pending);
    expect(c.qrUrl, 'https://qr.test/1.png');
    expect(c.expiresAt, DateTime.utc(2026, 10, 25, 8, 15));
    expect(adapter.requests.single.data, {
      'user_id': 'u1',
      'items': [
        {'product_id': 'p1', 'qty': 2.0},
      ],
    });
  });

  test('VA charge sends bank and customer', () async {
    adapter.on('POST', ApiPaths.paymentVa, (_) => FakeReply(201, envelope({
          'order_id': 'ORD-2',
          'method': 'va',
          'status': 'pending',
          'gross_amount': 11000,
          'va_number': '1234567890',
          'bank': 'bca',
        })));
    final c = (await ChargeVa(repo)(userId: 'u1', customerId: 'k1', bank: VaBank.bca, items: items) as Ok<Charge>).value;
    expect(c.method, ChargeMethod.va);
    expect(c.vaNumber, '1234567890');
    expect(adapter.requests.single.data['bank'], 'bca');
    expect(adapter.requests.single.data['customer_id'], 'k1');
  });

  test('empty carts are refused', () async {
    expect(await ChargeQris(repo)(userId: 'u1', items: []), const Err<Charge>(ValidationFailure('empty_cart')));
    expect(await ChargeVa(repo)(userId: 'u1', bank: VaBank.mandiri, items: []), const Err<Charge>(ValidationFailure('empty_cart')));
  });

  test('status maps final states and transaction id', () async {
    adapter.on('GET', ApiPaths.paymentStatus('ORD-1'), (_) => FakeReply(200, envelope({
          'order_id': 'ORD-1',
          'status': 'success',
          'gross_amount': 7070,
          'transaction_id': 't1',
          'paid_at': '2026-10-25T08:05:00Z',
        })));
    final s = (await CheckPaymentStatus(repo)('ORD-1') as Ok<ChargeStatus>).value;
    expect(s.state.isFinal, isTrue);
    expect(s.transactionId, 't1');
    expect(PaymentState.parse('settling').isFinal, isFalse);
    expect(PaymentState.parse('weird'), PaymentState.pending);
  });

  test('list maps payment records and filters', () async {
    adapter.on('GET', ApiPaths.payments, (_) => FakeReply(200, envelope({
          'has_next': false,
          'payments': [
            {'id': 'x', 'order_id': 'ORD-1', 'method': 'va', 'status': 'expired', 'gross_amount': 5000, 'fee_amount': 4000, 'va_bank': 'bca'},
          ],
        })));
    final page = (await GetPayments(repo)(PaymentQuery(state: PaymentState.expired, method: ChargeMethod.va, dateStart: DateTime(2026, 10, 25))) as Ok<Paged<PaymentRecord>>).value;
    expect(page.items.single.state, PaymentState.expired);
    expect(page.items.single.feeAmount, 4000);
    expect(adapter.requests.single.queryParameters, {'status': 'expired', 'method': 'va', 'date_start': '2026-10-25', 'limit': 20});
  });
}
