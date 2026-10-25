import 'package:drift/drift.dart';

/// Read-only copy of server products for offline search, scan, and checkout.
class CachedProducts extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  IntColumn get unit => integer().withDefault(const Constant(0))();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get purchasePrice => integer().withDefault(const Constant(0))();
  IntColumn get sellingPrice => integer()();
  IntColumn get sellingPriceDebt => integer()();
  RealColumn get stock => real().withDefault(const Constant(0))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text().withDefault(const Constant(''))();
  TextColumn get image => text().withDefault(const Constant(''))();

  /// Local sales count; drives "most sold first" ordering. Survives cache refresh.
  IntColumn get soldCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get productCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedCustomers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  IntColumn get outstandingDebt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Every sale made on this device: the offline queue (pending/failed) and the
/// local history used for receipts and reprints (synced).
@DataClassName('SaleRow')
class Sales extends Table {
  TextColumn get clientRef => text()();

  /// `OFF-<device>-<seq>` until synced, then the server invoice.
  TextColumn get receiptNumber => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get method => integer()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get cashierName => text()();
  IntColumn get total => integer()();

  /// JSON list of sale lines (product, name, qty, unit price, destination).
  TextColumn get linesJson => text()();

  /// 0 pending, 1 synced, 2 failed (not retryable), 3 cancelled.
  IntColumn get status => integer().withDefault(const Constant(0))();
  TextColumn get error => text().nullable()();
  TextColumn get transactionId => text().nullable()();
  BoolColumn get stockConflict => boolean().withDefault(const Constant(false))();
  TextColumn get cancelReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {clientRef};
}

/// One open "Transaksi N" tab.
class DraftCarts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// 0 open, 1 awaiting QRIS/VA, 2 paid (receipt not yet dismissed).
  IntColumn get status => integer().withDefault(const Constant(0))();

  /// JSON of the pending charge (order id, method, QR/VA data, amount).
  TextColumn get chargeJson => text().nullable()();

  /// Sale created when the charge settled; shown as receipt on return.
  TextColumn get paidSaleRef => text().nullable()();
}

class DraftCartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftId => integer().references(DraftCarts, #id, onDelete: KeyAction.cascade)();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  IntColumn get unitPrice => integer()();
  IntColumn get debtPrice => integer()();
  RealColumn get qty => real()();
  IntColumn get unit => integer().withDefault(const Constant(0))();
  BoolColumn get isDigital => boolean().withDefault(const Constant(false))();
  TextColumn get destination => text().nullable()();
  IntColumn get position => integer()();
}
