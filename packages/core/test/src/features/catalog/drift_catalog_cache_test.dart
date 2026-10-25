import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProducts extends Mock implements ProductRepository {}

class MockCategories extends Mock implements CategoryRepository {}

class MockCustomers extends Mock implements CustomerRepository {}

Product product(String id, {String name = 'Indomie', String? barcode, double stock = 10, String? category}) => Product(
      id: id,
      sku: 'S$id',
      barcode: barcode,
      name: name,
      sellingPrice: 3500,
      sellingPriceDebt: 4000,
      stock: stock,
      categoryId: category,
    );

void main() {
  late AppDatabase db;
  late DriftCatalogCache cache;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    cache = DriftCatalogCache(db);
  });
  tearDown(() => db.close());

  test('search matches name, sku, and exact barcode; most sold first', () async {
    await cache.replaceProducts([
      product('a', name: 'Aqua 600ml', barcode: '111'),
      product('b', name: 'Indomie Goreng', barcode: '222'),
      product('c', name: 'Indomie Soto'),
    ]);
    await cache.adjustStock({'c': -1}, countSale: true);
    final all = await cache.watchProducts().first;
    expect(all.map((p) => p.id), ['c', 'a', 'b']);
    expect((await cache.watchProducts(search: 'indomie').first).map((p) => p.id), ['c', 'b']);
    expect((await cache.watchProducts(search: 'Sa').first).map((p) => p.id), ['a']);
    expect((await cache.watchProducts(search: '222').first).single.id, 'b');
  });

  test('replace keeps sold counts and barcode lookup works', () async {
    await cache.replaceProducts([product('a', barcode: '111')]);
    await cache.adjustStock({'a': -2}, countSale: true);
    await cache.replaceProducts([product('a', barcode: '111', stock: 50), product('b')]);
    expect((await cache.watchProducts().first).first.id, 'a');
    expect((await cache.productByBarcode(' 111 '))?.stock, 50);
    expect(await cache.productByBarcode('999'), isNull);
  });

  test('stock adjustments clamp at zero', () async {
    await cache.replaceProducts([product('a', stock: 1)]);
    await cache.adjustStock({'a': -3});
    expect(await cache.stockOf(['a']), {'a': 0.0});
    await cache.adjustStock({'a': 2});
    expect((await cache.product('a'))?.stock, 2);
  });

  test('category filter and upsert', () async {
    await cache.replaceProducts([product('a', category: 'c1'), product('b', category: 'c2')]);
    expect((await cache.watchProducts(categoryId: 'c2').first).single.id, 'b');
    await cache.upsertProduct(product('b', name: 'Baru', category: 'c2'));
    expect((await cache.product('b'))?.name, 'Baru');
  });

  test('categories and customers round-trip', () async {
    await cache.replaceCategories(const [Category(id: 'c2', name: 'Minuman'), Category(id: 'c1', name: 'Bumbu', productCount: 2)]);
    expect((await cache.watchCategories().first).map((c) => c.name), ['Bumbu', 'Minuman']);
    await cache.replaceCustomers(const [Customer(id: 'k1', name: 'Bu Sri', phone: '0812')]);
    await cache.upsertCustomer(const Customer(id: 'k2', name: 'Pak Budi'));
    expect((await cache.watchCustomers(search: 'sri').first).single.id, 'k1');
    expect((await cache.watchCustomers(search: '0812').first).single.id, 'k1');
    expect((await cache.customer('k2'))?.name, 'Pak Budi');
    expect(await cache.customer('zz'), isNull);
  });

  test('RefreshCatalog applies each list and reports the first failure', () async {
    final products = MockProducts();
    final categories = MockCategories();
    final customers = MockCustomers();
    when(products.listAll).thenAnswer((_) async => Ok([product('a')]));
    when(categories.list).thenAnswer((_) async => const Err(NetworkFailure()));
    when(customers.listAll).thenAnswer((_) async => const Ok([Customer(id: 'k1', name: 'Bu Sri')]));
    final result = await RefreshCatalog(products, categories, customers, cache)();
    expect(result, const Err<void>(NetworkFailure()));
    expect(await cache.product('a'), isNotNull);
    expect(await cache.customer('k1'), isNotNull);

    when(categories.list).thenAnswer((_) async => const Ok([Category(id: 'c', name: 'X')]));
    expect(await RefreshCatalog(products, categories, customers, cache)(), isA<Ok<void>>());
  });
}
