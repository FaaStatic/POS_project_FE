import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../constants/payment_method.dart';
import '../../../database/app_database.dart';
import '../../../storage/key_value_store.dart';
import '../domain/entities/sale.dart';
import '../domain/repositories/sales_log.dart';

class DriftSalesLog implements SalesLog {
  DriftSalesLog(this._db, this._store, {Random? random}) : _random = random ?? Random.secure();

  final AppDatabase _db;
  final KeyValueStore _store;
  final Random _random;

  static const _deviceCodeKey = 'device_code';
  static const _seqKey = 'offline_seq';

  @override
  Future<void> add(Sale sale) => _db.into(_db.sales).insertOnConflictUpdate(_companion(sale));

  @override
  Stream<List<Sale>> watchAll({int limit = 200}) => (_db.select(_db.sales)
        ..orderBy([(s) => OrderingTerm.desc(s.createdAt)])
        ..limit(limit))
      .watch()
      .map((rows) => rows.map(_sale).toList());

  @override
  Stream<int> watchPendingCount() {
    final count = _db.sales.clientRef.count();
    return (_db.selectOnly(_db.sales)
          ..addColumns([count])
          ..where(_db.sales.status.equals(SaleStatus.pending.index)))
        .watchSingle()
        .map((row) => row.read(count) ?? 0);
  }

  @override
  Future<List<Sale>> pending({int limit = 100}) async => (await (_db.select(_db.sales)
            ..where((s) => s.status.equals(SaleStatus.pending.index))
            ..orderBy([(s) => OrderingTerm.asc(s.createdAt)])
            ..limit(limit))
          .get())
      .map(_sale)
      .toList();

  @override
  Future<Sale?> byRef(String clientRef) async {
    final row = await (_db.select(_db.sales)..where((s) => s.clientRef.equals(clientRef))).getSingleOrNull();
    return row == null ? null : _sale(row);
  }

  @override
  Future<Sale?> byTransactionId(String transactionId) async {
    final row = await (_db.select(_db.sales)..where((s) => s.transactionId.equals(transactionId))).getSingleOrNull();
    return row == null ? null : _sale(row);
  }

  @override
  Future<void> markSynced(String clientRef, {String? transactionId, String? invoice, bool stockConflict = false}) =>
      (_db.update(_db.sales)..where((s) => s.clientRef.equals(clientRef))).write(SalesCompanion(
        status: Value(SaleStatus.synced.index),
        transactionId: Value(transactionId),
        receiptNumber: invoice == null || invoice.isEmpty ? const Value.absent() : Value(invoice),
        stockConflict: Value(stockConflict),
        error: const Value(null),
      ));

  @override
  Future<void> markFailed(String clientRef, String error, {required bool retryable}) =>
      (_db.update(_db.sales)..where((s) => s.clientRef.equals(clientRef))).write(SalesCompanion(
        status: Value(retryable ? SaleStatus.pending.index : SaleStatus.failed.index),
        error: Value(error),
      ));

  @override
  Future<void> markCancelled(String clientRef, String reason) =>
      (_db.update(_db.sales)..where((s) => s.clientRef.equals(clientRef))).write(SalesCompanion(
        status: Value(SaleStatus.cancelled.index),
        cancelReason: Value(reason),
      ));

  @override
  Future<String> nextOfflineNumber() async {
    var code = _store.getString(_deviceCodeKey);
    if (code == null) {
      const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
      code = List.generate(4, (_) => alphabet[_random.nextInt(alphabet.length)]).join();
      await _store.setString(_deviceCodeKey, code);
    }
    final seq = (_store.getInt(_seqKey) ?? 0) + 1;
    await _store.setInt(_seqKey, seq);
    return 'OFF-$code-$seq';
  }

  static Sale _sale(SaleRow r) => Sale(
        clientRef: r.clientRef,
        receiptNumber: r.receiptNumber,
        createdAt: r.createdAt,
        method: PaymentMethod.fromIndex(r.method),
        customerId: r.customerId,
        customerName: r.customerName,
        cashierName: r.cashierName,
        total: r.total,
        lines: [
          for (final l in (jsonDecode(r.linesJson) as List).cast<Map<String, dynamic>>())
            SaleLine(
              productId: l['product_id'] as String,
              name: l['name'] as String,
              qty: (l['qty'] as num).toDouble(),
              unitPrice: (l['unit_price'] as num).toInt(),
              destination: l['destination'] as String?,
            ),
        ],
        status: SaleStatus.values[r.status],
        error: r.error,
        transactionId: r.transactionId,
        stockConflict: r.stockConflict,
        cancelReason: r.cancelReason,
      );

  static SalesCompanion _companion(Sale s) => SalesCompanion.insert(
        clientRef: s.clientRef,
        receiptNumber: s.receiptNumber,
        createdAt: s.createdAt,
        method: s.method.index,
        customerId: Value(s.customerId),
        customerName: Value(s.customerName),
        cashierName: s.cashierName,
        total: s.total,
        linesJson: jsonEncode([
          for (final l in s.lines)
            {
              'product_id': l.productId,
              'name': l.name,
              'qty': l.qty,
              'unit_price': l.unitPrice,
              'destination': ?l.destination,
            },
        ]),
        status: Value(s.status.index),
        error: Value(s.error),
        transactionId: Value(s.transactionId),
        stockConflict: Value(s.stockConflict),
        cancelReason: Value(s.cancelReason),
      );
}
