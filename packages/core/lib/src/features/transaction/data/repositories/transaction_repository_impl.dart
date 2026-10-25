import '../../../../common/guard.dart';
import '../../../../common/json.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/api_paths.dart';
import '../../../../format/formatters.dart';
import '../../../../network/api_client.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDatasource {
  const TransactionRemoteDatasource(this._api);
  final ApiClient _api;

  Future<CheckoutResult> create(CheckoutRequest r) async =>
      TransactionModel.checkoutResultFromJson(readMap(await _api.post(ApiPaths.transactions, body: TransactionModel.checkoutToJson(r))));

  Future<Transaction> get(String id) async => TransactionModel.fromJson(readMap(await _api.get(ApiPaths.transaction(id))));

  Future<Page<Transaction>> list(TransactionQuery q, {PageCursor? after}) => _page(ApiPaths.transactions, {
        'date_start': q.dateStart == null ? null : apiDate(q.dateStart!),
        'date_end': q.dateEnd == null ? null : apiDate(q.dateEnd!),
        'type_payment': q.method?.index,
        'number_invoices': q.invoice,
        'open_conflict': q.openConflict ? true : null,
        'limit': q.limit,
        'after_id': after?.id,
        'after_time': after?.time,
      });

  Future<Page<Transaction>> listByCustomer(String customerId, {PageCursor? after}) =>
      _page(ApiPaths.customerTransactions(customerId), {'limit': 20, 'after_id': after?.id, 'after_time': after?.time});

  Future<Page<Transaction>> _page(String path, Map<String, dynamic> query) async {
    final data = readMap(await _api.get(path, query: query));
    return Page(
      items: readList(data['list_transaction']).map(TransactionModel.fromJson).toList(),
      cursor: PageCursor.from(data['after_id'], data['after_time']),
      hasNext: readBool(data['has_next']),
    );
  }

  Future<void> cancel(String id, String reason) => _api.delete(ApiPaths.transaction(id), body: {'trx_id': id, 'reason': reason});

  Future<List<SyncResult>> sync(List<OfflineSale> sales) async {
    final data = readMap(await _api.post(ApiPaths.transactionsSync, body: {
      'transactions': sales.map(TransactionModel.offlineToJson).toList(),
    }));
    return readList(data['results']).map(TransactionModel.syncResultFromJson).toList();
  }

  Future<void> markReviewed(String id) => _api.patch(ApiPaths.transactionConflictReview(id));

  Future<String> receiptPdf(String id) async =>
      readString(readMap(await _api.get(ApiPaths.reportTransaction, query: {'trx_id': id}))['url_pdf']);

  Future<String> monthlyPdf(int month, int year) async =>
      readString(readMap(await _api.get(ApiPaths.reportMonth, query: {'month': month, 'year': year}))['url_pdf']);
}

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._remote);
  final TransactionRemoteDatasource _remote;

  @override
  Future<Result<CheckoutResult>> create(CheckoutRequest request) => guard(() => _remote.create(request));
  @override
  Future<Result<Transaction>> get(String id) => guard(() => _remote.get(id));
  @override
  Future<Result<Page<Transaction>>> list(TransactionQuery query, {PageCursor? after}) =>
      guard(() => _remote.list(query, after: after));
  @override
  Future<Result<Page<Transaction>>> listByCustomer(String customerId, {PageCursor? after}) =>
      guard(() => _remote.listByCustomer(customerId, after: after));
  @override
  Future<Result<void>> cancel(String id, String reason) => guard(() => _remote.cancel(id, reason));
  @override
  Future<Result<List<SyncResult>>> sync(List<OfflineSale> sales) => guard(() => _remote.sync(sales));
  @override
  Future<Result<void>> markConflictReviewed(String id) => guard(() => _remote.markReviewed(id));
  @override
  Future<Result<String>> receiptPdf(String id) => guard(() => _remote.receiptPdf(id));
  @override
  Future<Result<String>> monthlyReportPdf(int month, int year) => guard(() => _remote.monthlyPdf(month, year));
}
