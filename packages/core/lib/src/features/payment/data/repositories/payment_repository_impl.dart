import '../../../../common/guard.dart';
import '../../../../common/json.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/api_paths.dart';
import '../../../../constants/payment_method.dart';
import '../../../../format/formatters.dart';
import '../../../../network/api_client.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

ChargeMethod _method(Object? raw) => readString(raw).toLowerCase() == 'va' ? ChargeMethod.va : ChargeMethod.qris;

Charge chargeFromJson(Map<String, dynamic> j) => Charge(
      orderId: readString(j['order_id']),
      method: _method(j['method']),
      state: PaymentState.parse(readString(j['status'])),
      grossAmount: readInt(j['gross_amount']),
      qrString: readNullableString(j['qr_string']),
      qrUrl: readNullableString(j['qr_url']),
      vaNumber: readNullableString(j['va_number']),
      bank: readNullableString(j['bank']),
      billKey: readNullableString(j['bill_key']),
      billerCode: readNullableString(j['biller_code']),
      expiresAt: readDate(j['expiry_time']),
    );

PaymentRecord paymentRecordFromJson(Map<String, dynamic> j) => PaymentRecord(
      id: readString(j['id']),
      orderId: readString(j['order_id']),
      method: _method(j['method']),
      state: PaymentState.parse(readString(j['status'])),
      grossAmount: readInt(j['gross_amount']),
      feeAmount: readInt(j['fee_amount']),
      midtransStatus: readNullableString(j['midtrans_status']),
      vaBank: readNullableString(j['va_bank']),
      vaNumber: readNullableString(j['va_number']),
      transactionId: readNullableString(j['transaction_id']),
      expiresAt: readDate(j['expiry_time']),
      paidAt: readDate(j['paid_at']),
      createdAt: readDate(j['created_at']),
    );

class PaymentRemoteDatasource {
  const PaymentRemoteDatasource(this._api);
  final ApiClient _api;

  Map<String, dynamic> _body(String userId, String? customerId, List<ChargeItem> items) => {
        'user_id': userId,
        'customer_id': ?customerId,
        'items': [for (final i in items) {'product_id': i.productId, 'qty': i.qty}],
      };

  Future<Charge> qris(String userId, String? customerId, List<ChargeItem> items) async =>
      chargeFromJson(readMap(await _api.post(ApiPaths.paymentQris, body: _body(userId, customerId, items))));

  Future<Charge> va(String userId, String? customerId, VaBank bank, List<ChargeItem> items) async =>
      chargeFromJson(readMap(await _api.post(ApiPaths.paymentVa, body: {..._body(userId, customerId, items), 'bank': bank.name})));

  Future<ChargeStatus> status(String orderId) async {
    final j = readMap(await _api.get(ApiPaths.paymentStatus(orderId)));
    return ChargeStatus(
      orderId: readString(j['order_id']),
      state: PaymentState.parse(readString(j['status'])),
      grossAmount: readInt(j['gross_amount']),
      transactionId: readNullableString(j['transaction_id']),
      paidAt: readDate(j['paid_at']),
    );
  }

  Future<Page<PaymentRecord>> list(PaymentQuery q, {PageCursor? after}) async {
    final data = readMap(await _api.get(ApiPaths.payments, query: {
      'status': q.state?.name,
      'method': q.method?.name,
      'date_start': q.dateStart == null ? null : apiDate(q.dateStart!),
      'date_end': q.dateEnd == null ? null : apiDate(q.dateEnd!),
      'limit': q.limit,
      'after_id': after?.id,
      'after_time': after?.time,
    }));
    return Page(
      items: readList(data['payments']).map(paymentRecordFromJson).toList(),
      cursor: PageCursor.from(data['after_id'], data['after_time']),
      hasNext: readBool(data['has_next']),
    );
  }
}

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this._remote);
  final PaymentRemoteDatasource _remote;

  @override
  Future<Result<Charge>> chargeQris({required String userId, String? customerId, required List<ChargeItem> items}) =>
      guard(() => _remote.qris(userId, customerId, items));
  @override
  Future<Result<Charge>> chargeVa({
    required String userId,
    String? customerId,
    required VaBank bank,
    required List<ChargeItem> items,
  }) =>
      guard(() => _remote.va(userId, customerId, bank, items));
  @override
  Future<Result<ChargeStatus>> status(String orderId) => guard(() => _remote.status(orderId));
  @override
  Future<Result<Page<PaymentRecord>>> list(PaymentQuery query, {PageCursor? after}) =>
      guard(() => _remote.list(query, after: after));
}
