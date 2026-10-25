import 'package:drift/drift.dart';

import '../../../database/app_database.dart';
import '../../category/domain/entities/category.dart';
import '../../customer/domain/entities/customer.dart';
import '../../product/domain/entities/product.dart';
import '../domain/repositories/catalog_cache.dart';

class DriftCatalogCache implements CatalogCache {
  const DriftCatalogCache(this._db);
  final AppDatabase _db;

  @override
  Stream<List<Product>> watchProducts({String? search, String? categoryId}) {
    final q = _db.select(_db.cachedProducts);
    final term = search?.trim().toLowerCase();
    if (term != null && term.isNotEmpty) {
      final like = '%$term%';
      q.where((p) => p.name.lower().like(like) | p.sku.lower().like(like) | p.barcode.equals(search!.trim()));
    }
    if (categoryId != null) q.where((p) => p.categoryId.equals(categoryId));
    q.orderBy([(p) => OrderingTerm.desc(p.soldCount), (p) => OrderingTerm.asc(p.name)]);
    return q.watch().map((rows) => rows.map(_product).toList());
  }

  @override
  Future<Product?> productByBarcode(String barcode) async {
    final row = await (_db.select(_db.cachedProducts)..where((p) => p.barcode.equals(barcode.trim()))).getSingleOrNull();
    return row == null ? null : _product(row);
  }

  @override
  Future<Product?> product(String id) async {
    final row = await (_db.select(_db.cachedProducts)..where((p) => p.id.equals(id))).getSingleOrNull();
    return row == null ? null : _product(row);
  }

  @override
  Future<Map<String, double>> stockOf(Iterable<String> productIds) async {
    final rows = await (_db.select(_db.cachedProducts)..where((p) => p.id.isIn(productIds))).get();
    return {for (final r in rows) r.id: r.stock};
  }

  @override
  Future<void> replaceProducts(List<Product> products) => _db.transaction(() async {
        final sold = {
          for (final r in await _db.select(_db.cachedProducts).get()) r.id: r.soldCount,
        };
        await _db.delete(_db.cachedProducts).go();
        await _db.batch((b) => b.insertAll(
              _db.cachedProducts,
              [for (final p in products) _companion(p, soldCount: sold[p.id] ?? 0)],
            ));
      });

  @override
  Future<void> upsertProduct(Product product) async {
    final existing = await (_db.select(_db.cachedProducts)..where((p) => p.id.equals(product.id))).getSingleOrNull();
    await _db.into(_db.cachedProducts).insertOnConflictUpdate(_companion(product, soldCount: existing?.soldCount ?? 0));
  }

  @override
  Future<void> adjustStock(Map<String, double> deltas, {bool countSale = false}) => _db.transaction(() async {
        for (final MapEntry(key: id, value: delta) in deltas.entries) {
          // Stock never goes below zero locally either; the server flags the shortfall.
          await _db.customUpdate(
            'UPDATE cached_products SET stock = MAX(0, stock + ?)${countSale ? ', sold_count = sold_count + 1' : ''} WHERE id = ?',
            variables: [Variable.withReal(delta), Variable.withString(id)],
            updates: {_db.cachedProducts},
          );
        }
      });

  @override
  Stream<List<Category>> watchCategories() =>
      (_db.select(_db.cachedCategories)..orderBy([(c) => OrderingTerm.asc(c.name)])).watch().map(
            (rows) => [for (final r in rows) Category(id: r.id, name: r.name, productCount: r.productCount)],
          );

  @override
  Future<void> replaceCategories(List<Category> categories) => _db.transaction(() async {
        await _db.delete(_db.cachedCategories).go();
        await _db.batch((b) => b.insertAll(_db.cachedCategories, [
              for (final c in categories)
                CachedCategoriesCompanion.insert(id: c.id, name: c.name, productCount: Value(c.productCount)),
            ]));
      });

  @override
  Stream<List<Customer>> watchCustomers({String? search}) {
    final q = _db.select(_db.cachedCustomers);
    final term = search?.trim().toLowerCase();
    if (term != null && term.isNotEmpty) {
      q.where((c) => c.name.lower().like('%$term%') | c.phone.like('%$term%'));
    }
    q.orderBy([(c) => OrderingTerm.asc(c.name)]);
    return q.watch().map((rows) => rows.map(_customer).toList());
  }

  @override
  Future<Customer?> customer(String id) async {
    final row = await (_db.select(_db.cachedCustomers)..where((c) => c.id.equals(id))).getSingleOrNull();
    return row == null ? null : _customer(row);
  }

  @override
  Future<void> replaceCustomers(List<Customer> customers) => _db.transaction(() async {
        await _db.delete(_db.cachedCustomers).go();
        await _db.batch((b) => b.insertAll(_db.cachedCustomers, [for (final c in customers) _customerCompanion(c)]));
      });

  @override
  Future<void> upsertCustomer(Customer customer) =>
      _db.into(_db.cachedCustomers).insertOnConflictUpdate(_customerCompanion(customer));

  static Product _product(CachedProduct r) => Product(
        id: r.id,
        sku: r.sku,
        barcode: r.barcode,
        name: r.name,
        unit: ProductUnit.values[r.unit.clamp(0, ProductUnit.values.length - 1)],
        type: ProductType.values[r.type.clamp(0, ProductType.values.length - 1)],
        purchasePrice: r.purchasePrice,
        sellingPrice: r.sellingPrice,
        sellingPriceDebt: r.sellingPriceDebt,
        stock: r.stock,
        categoryId: r.categoryId,
        categoryName: r.categoryName,
        image: r.image,
      );

  static CachedProductsCompanion _companion(Product p, {required int soldCount}) => CachedProductsCompanion.insert(
        id: p.id,
        sku: p.sku,
        barcode: Value(p.barcode),
        name: p.name,
        unit: Value(p.unit.index),
        type: Value(p.type.index),
        purchasePrice: Value(p.purchasePrice),
        sellingPrice: p.sellingPrice,
        sellingPriceDebt: p.sellingPriceDebt,
        stock: Value(p.stock),
        categoryId: Value(p.categoryId),
        categoryName: Value(p.categoryName),
        image: Value(p.image),
        soldCount: Value(soldCount),
      );

  /// The cache keeps only the outstanding total, not individual debts.
  static Customer _customer(CachedCustomer r) => Customer(id: r.id, name: r.name, phone: r.phone, address: r.address);

  static CachedCustomersCompanion _customerCompanion(Customer c) => CachedCustomersCompanion.insert(
        id: c.id,
        name: c.name,
        phone: Value(c.phone),
        address: Value(c.address),
        outstandingDebt: Value(c.outstandingDebt),
      );
}
