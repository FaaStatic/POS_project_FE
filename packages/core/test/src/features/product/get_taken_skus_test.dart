import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProducts extends Mock implements ProductRepository {}

Product _p(String id, String sku) => Product(id: id, sku: sku, name: 'x', sellingPrice: 1, sellingPriceDebt: 1);

void main() {
  late _MockProducts repo;

  setUpAll(() => registerFallbackValue(const ProductQuery()));
  setUp(() => repo = _MockProducts());

  void serve(String categoryId, List<Paged<Product>> pages) {
    var call = 0;
    when(() => repo.list(any(that: isA<ProductQuery>().having((q) => q.categoryId, 'categoryId', categoryId)), after: any(named: 'after')))
        .thenAnswer((_) async => Ok(pages[call++]));
  }

  test('reads every page of a category and keeps only the SKUs', () async {
    serve('c1', [
      Paged(items: [_p('1', 'MIE-P-IG-001'), _p('2', 'MIE-P-IG-002')], cursor: const PageCursor(id: '2', time: 't2'), hasNext: true),
      Paged(items: [_p('3', 'MIE-P-IG-003')]),
    ]);

    final result = await GetTakenSkus(repo)(['c1']);

    expect((result as Ok<Set<String>>).value, {'MIE-P-IG-001', 'MIE-P-IG-002', 'MIE-P-IG-003'});
    final cursors = verify(() => repo.list(any(), after: captureAny(named: 'after'))).captured;
    expect(cursors.first, isNull, reason: 'the first page has no cursor');
    expect((cursors.last as PageCursor).id, '2', reason: 'the second page continues from the first');
  });

  test('asks for full pages', () async {
    serve('c1', [const Paged(items: [])]);
    await GetTakenSkus(repo)(['c1']);
    final query = verify(() => repo.list(captureAny(), after: any(named: 'after'))).captured.single as ProductQuery;
    expect(query.limit, 100);
  });

  test('merges several categories and asks for each once', () async {
    serve('c1', [Paged(items: [_p('1', 'MIE-P-IG-001')])]);
    serve('c2', [Paged(items: [_p('2', 'MIN-P-IG-001')])]);

    final result = await GetTakenSkus(repo)(['c1', 'c2', 'c1']);

    expect((result as Ok<Set<String>>).value, {'MIE-P-IG-001', 'MIN-P-IG-001'});
    verify(() => repo.list(any(), after: any(named: 'after'))).called(2);
  });

  test('no categories means nothing to ask', () async {
    final result = await GetTakenSkus(repo)([]);
    expect((result as Ok<Set<String>>).value, isEmpty);
    verifyNever(() => repo.list(any(), after: any(named: 'after')));
  });

  test('a failed page fails the whole read, so a half-known list is never used', () async {
    serve('c1', [Paged(items: [_p('1', 'MIE-P-IG-001')])]);
    when(() => repo.list(any(that: isA<ProductQuery>().having((q) => q.categoryId, 'categoryId', 'c2')), after: any(named: 'after')))
        .thenAnswer((_) async => const Err(NetworkFailure()));

    final result = await GetTakenSkus(repo)(['c1', 'c2']);

    expect(result, isA<Err<Set<String>>>());
  });
}
