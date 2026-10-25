import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> trxJson(String id) => {
      'transaction_id': id,
      'invoice_number': 'INV-1',
      'payment_type': 1,
      'total_transaction': 7000,
      'total_profit': 2000,
      'stock_conflict': true,
      'conflict_reviewed': false,
      'created_at': '2026-10-25T08:00:00Z',
      'transaction_details': [
        {'product_id': 'p1', 'product_name': 'Indomie', 'price': 3500, 'qty': 2, 'subtotal': 7000},
      ],
    };

void main() {
  late FakeAdapter adapter;
  late TransactionRepositoryImpl repo;
  const line = CheckoutLine(productId: 'p1', qty: 2, unitPrice: 3500);

  setUp(() {
    adapter = FakeAdapter();
    repo = TransactionRepositoryImpl(TransactionRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('create sends wire payment type and maps the result', () async {
    adapter.on('POST', ApiPaths.transactions, (_) => FakeReply(201, envelope({
          'transaction_id': 't1',
          'no_invoice': 'INV-9',
          'total_transaction': 7000,
          'payment_type': 'hutang',
          'stock_conflict': false,
          'debt_info': {'remaining_debt': 12000},
        })));
    final req = const CheckoutRequest(
      userId: 'u1',
      method: PaymentMethod.debt,
      customerId: 'k1',
      lines: [CheckoutLine(productId: 'p1', qty: 2, unitPrice: 4000, destination: '0812')],
    );
    final r = (await CreateTransaction(repo)(req) as Ok<CheckoutResult>).value;
    expect(r.invoice, 'INV-9');
    expect(r.method, PaymentMethod.debt);
    expect(r.debtRemaining, 12000);
    expect(adapter.requests.single.data, {
      'no_invoice': '',
      'type_payment': 'hutang',
      'user_id': 'u1',
      'customer_id': 'k1',
      'details': [
        {'product_id': 'p1', 'qty': 2.0, 'destination': '0812'},
      ],
    });
  });

  test('checkout validation', () {
    expect(validateCheckout(PaymentMethod.cash, null, []), 'empty_cart');
    expect(validateCheckout(PaymentMethod.cash, null, [line.copyWith(qty: 0)]), 'invalid_qty');
    expect(validateCheckout(PaymentMethod.debt, null, [line]), 'debt_needs_customer');
    expect(validateCheckout(PaymentMethod.cash, null, [line.copyWith(destination: ' ')]), 'destination_required');
    expect(validateCheckout(PaymentMethod.cash, null, [line]), isNull);
  });

  test('CreateTransaction refuses invalid carts without a request', () async {
    final r = await CreateTransaction(repo)(const CheckoutRequest(userId: 'u1', method: PaymentMethod.cash, lines: []));
    expect(r, const Err<CheckoutResult>(ValidationFailure('empty_cart')));
    expect(adapter.requests, isEmpty);
  });

  test('get and list map transactions and filters', () async {
    adapter
      ..on('GET', ApiPaths.transaction('t1'), (_) => FakeReply(200, envelope(trxJson('t1'))))
      ..on('GET', ApiPaths.transactions, (_) => FakeReply(200, envelope({'has_next': false, 'list_transaction': [trxJson('t1')]})))
      ..on('GET', ApiPaths.customerTransactions('k1'), (_) => FakeReply(200, envelope({'list_transaction': [trxJson('t2')]})));
    final t = (await GetTransaction(repo)('t1') as Ok<Transaction>).value;
    expect(t.method, PaymentMethod.debt);
    expect(t.items.single.qty, 2);
    expect(t.stockConflict, isTrue);
    await GetTransactions(repo)(TransactionQuery(dateStart: DateTime(2026, 10, 1), method: PaymentMethod.qris, openConflict: true));
    expect(adapter.requests.last.queryParameters, {'date_start': '2026-10-01', 'type_payment': 3, 'open_conflict': true, 'limit': 20});
    expect((await GetCustomerTransactions(repo)('k1') as Ok<Page<Transaction>>).value.items.single.id, 't2');
  });

  test('cancel requires 3-500 char reason and sends it', () async {
    adapter.on('DELETE', ApiPaths.transaction('t1'), (_) => FakeReply(200, envelope(null)));
    expect(await CancelTransaction(repo)('t1', 'no'), const Err<void>(ValidationFailure('reason_length')));
    expect(await CancelTransaction(repo)('t1', ' salah input '), isA<Ok<void>>());
    expect(adapter.requests.single.data, {'trx_id': 't1', 'reason': 'salah input'});
  });

  test('sync sends snapshot prices and maps per-item results', () async {
    adapter.on('POST', ApiPaths.transactionsSync, (_) => FakeReply(200, envelope({
          'results': [
            {'client_ref': 'a', 'status': 'created', 'transaction_id': 't1', 'no_invoice': 'INV-1', 'stock_conflict': true, 'retryable': false},
            {'client_ref': 'b', 'status': 'duplicate', 'retryable': false},
            {'client_ref': 'c', 'status': 'failed', 'retryable': false, 'error': 'product not found'},
          ],
        })));
    final sale = OfflineSale(clientRef: 'a', createdAt: DateTime.utc(2026, 10, 25, 1), method: PaymentMethod.cash, lines: const [line]);
    final results = (await repo.sync([sale]) as Ok<List<SyncResult>>).value;
    expect(results.map((r) => r.accepted), [true, true, false]);
    expect(results.first.stockConflict, isTrue);
    expect(results.last.error, 'product not found');
    final body = adapter.requests.single.data['transactions'].single as Map;
    expect(body['created_at_client'], '2026-10-25T01:00:00.000Z');
    expect(body['details'].single, {'product_id': 'p1', 'qty': 2.0, 'unit_price': 3500});
  });

  test('conflict review and PDFs', () async {
    adapter
      ..on('PATCH', ApiPaths.transactionConflictReview('t1'), (_) => FakeReply(200, envelope(null)))
      ..on('GET', ApiPaths.reportTransaction, (_) => FakeReply(200, envelope({'url_pdf': '/api/reports/inv.pdf'})))
      ..on('GET', ApiPaths.reportMonth, (_) => FakeReply(200, envelope({'url_pdf': '/api/reports/oct.pdf'})));
    expect(await MarkConflictReviewed(repo)('t1'), isA<Ok<void>>());
    expect(await GetReceiptPdf(repo)('t1'), const Ok('/api/reports/inv.pdf'));
    expect(await GetMonthlyReportPdf(repo)(10, 2026), const Ok('/api/reports/oct.pdf'));
  });
}
