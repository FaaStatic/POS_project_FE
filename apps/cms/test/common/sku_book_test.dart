import 'package:cms/common/sku_book.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProducts extends Mock implements ProductRepository {}

const _mie = Category(id: 'c1', name: 'Mie Instan');
const _minuman = Category(id: 'c2', name: 'Minuman');
const _minyak = Category(id: 'c3', name: 'Minyak Goreng');

Product _p(String sku) => Product(id: sku, sku: sku, name: 'x', sellingPrice: 1, sellingPriceDebt: 1);

void main() {
  late _MockProducts repo;
  late SkuBook book;

  setUpAll(() => registerFallbackValue(const ProductQuery()));

  void takenIn(String categoryId, List<String> skus) =>
      when(() => repo.list(any(that: isA<ProductQuery>().having((q) => q.categoryId, 'categoryId', categoryId)), after: any(named: 'after')))
          .thenAnswer((_) async => Ok(Paged(items: [for (final s in skus) _p(s)])));

  setUp(() {
    repo = _MockProducts();
    book = SkuBook(GetTakenSkus(repo))..categories = [_mie, _minuman, _minyak];
    takenIn('c1', []);
    takenIn('c2', []);
    takenIn('c3', []);
  });

  Future<String?> next(String category, String name, {ProductType type = ProductType.physical, Iterable<String> reserved = const []}) =>
      book.next(category: category, type: type, name: name, reserved: reserved);

  test('builds category, type, name acronym, and 001 for the first product', () async {
    expect(await next('Mie Instan', 'Indomie Goreng'), 'MIE-P-IG-001');
  });

  test('continues after the SKUs the category already has', () async {
    takenIn('c1', ['MIE-P-IG-001', 'MIE-P-IG-002', 'MIE-P-SG-001']);
    expect(await next('Mie Instan', 'Indomie Goreng'), 'MIE-P-IG-003');
  });

  test('digital products get a D', () async {
    expect(await next('Mie Instan', 'Indomie Goreng', type: ProductType.digital), 'MIE-D-IG-001');
  });

  test('categories that share a code are read together, so their numbers do not collide', () async {
    // Minuman and Minyak Goreng are both MIN; each holds a number under the same prefix.
    takenIn('c2', ['MIN-P-TP-001']);
    takenIn('c3', ['MIN-P-TP-002']);
    expect(await next('Minuman', 'Teh Pucuk'), 'MIN-P-TP-003');
    expect(await next('Minyak Goreng', 'Teh Pucuk'), 'MIN-P-TP-003');
  });

  test('a category that does not exist yet has nothing taken, and starts at 001', () async {
    expect(await next('Frozen', 'Nugget Ayam'), 'FRO-P-NA-001');
    verifyNever(() => repo.list(any(), after: any(named: 'after')));
  });

  test('SKUs reserved by other rows count as taken', () async {
    expect(await next('Mie Instan', 'Indomie Goreng', reserved: ['MIE-P-IG-001', 'MIE-P-IG-002']), 'MIE-P-IG-003');
  });

  test('a code is read from the backend once, however many SKUs are asked for', () async {
    await next('Mie Instan', 'Indomie Goreng');
    await next('Mie Instan', 'Sedaap Goreng');
    await next('mie instan', 'Indomie Soto');
    verify(() => repo.list(any(), after: any(named: 'after'))).called(1);
  });

  test('nothing is built while the category or name is missing', () async {
    expect(await next('', 'Indomie Goreng'), isNull);
    expect(await next('Mie Instan', ''), isNull);
  });

  test('when the backend cannot be read there is no SKU, and the next try reads again', () async {
    when(() => repo.list(any(that: isA<ProductQuery>().having((q) => q.categoryId, 'categoryId', 'c1')), after: any(named: 'after')))
        .thenAnswer((_) async => const Err(NetworkFailure()));
    expect(await next('Mie Instan', 'Indomie Goreng'), isNull);

    takenIn('c1', ['MIE-P-IG-001']);
    expect(await next('Mie Instan', 'Indomie Goreng'), 'MIE-P-IG-002', reason: 'a failure is not remembered');
  });

  test('changing the categories drops what was read, so a renamed or added category is seen', () async {
    takenIn('c1', ['MIE-P-IG-001']);
    expect(await next('Mie Instan', 'Indomie Goreng'), 'MIE-P-IG-002');
    takenIn('c1', ['MIE-P-IG-001', 'MIE-P-IG-002']);
    book.categories = [_mie, _minuman];
    expect(await next('Mie Instan', 'Indomie Goreng'), 'MIE-P-IG-003');
  });
}
