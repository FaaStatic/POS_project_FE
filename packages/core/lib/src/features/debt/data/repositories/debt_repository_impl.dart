import '../../../../common/guard.dart';
import '../../../../common/json.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/api_paths.dart';
import '../../../../format/formatters.dart';
import '../../../../network/api_client.dart';
import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';

/// DebtResponseDto. `status` is "Lunas" / "Belum Lunas".
Debt debtFromJson(Map<String, dynamic> j) => Debt(
      id: readString(j['debt_id']),
      customerId: readString(j['customer_id']),
      customerName: readString(j['name_customer']),
      total: readInt(j['total_debt']),
      remaining: readInt(j['remaining_debt']),
      paid: readString(j['status']).toLowerCase() == 'lunas',
      date: readDate(j['date_debt']),
    );

class DebtRemoteDatasource {
  const DebtRemoteDatasource(this._api);
  final ApiClient _api;

  Future<Paged<Debt>> list(DebtQuery q, {PageCursor? after}) async {
    final data = readMap(await _api.get(ApiPaths.debts, query: {
      'customer_id': q.customerId,
      'search': q.search,
      'status': q.unpaidOnly ? 0 : null,
      'order': q.oldestFirst ? 'asc' : null,
      'limit': q.limit,
      'after_id': after?.id,
      'after_time': after?.time,
    }));
    return Paged(
      items: readList(data['transaction_list']).map(debtFromJson).toList(),
      cursor: PageCursor.from(data['after_id'], data['after_time']),
      hasNext: readBool(data['has_next']),
    );
  }

  Future<Debt> get(String id) async => debtFromJson(readMap(await _api.get(ApiPaths.debt(id))));

  Future<DebtPaymentReceipt> pay(String debtId, String userId, int amount, String key) async {
    final j = readMap(await _api.post(ApiPaths.debtPay, body: {
      'debt_id': debtId,
      'user_id': userId,
      'nominal_bayar': amount,
      'idempotency_key': key,
    }));
    return DebtPaymentReceipt(
      debtId: readString(j['debt_id']),
      customerName: readString(j['customer_name']),
      amount: readInt(j['nominal_bayar']),
      previousRemaining: readInt(j['previous_remaining_debt']),
      remaining: readInt(j['remaining_debt']),
      paid: readString(j['status']).toLowerCase() == 'lunas',
      paidAt: readDate(j['paid_at']),
    );
  }

  Future<void> add(String customerId, int amount, DateTime? dueDate) => _api.post(ApiPaths.debts, body: {
        'customer_id': customerId,
        'total_transaksi': amount,
        if (dueDate != null) 'jatuh_tempo': apiDate(dueDate),
      });
}

class DebtRepositoryImpl implements DebtRepository {
  const DebtRepositoryImpl(this._remote);
  final DebtRemoteDatasource _remote;

  @override
  Future<Result<Paged<Debt>>> list(DebtQuery query, {PageCursor? after}) => guard(() => _remote.list(query, after: after));
  @override
  Future<Result<Debt>> get(String id) => guard(() => _remote.get(id));
  @override
  Future<Result<DebtPaymentReceipt>> pay({
    required String debtId,
    required String userId,
    required int amount,
    required String idempotencyKey,
  }) =>
      guard(() => _remote.pay(debtId, userId, amount, idempotencyKey));
  @override
  Future<Result<void>> add({required String customerId, required int amount, DateTime? dueDate}) =>
      guard(() => _remote.add(customerId, amount, dueDate));
}
