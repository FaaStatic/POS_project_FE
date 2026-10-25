import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAdapter adapter;
  late CategoryRepositoryImpl repo;
  const existing = [Category(id: 'c1', name: 'Sembako', productCount: 3)];

  setUp(() {
    adapter = FakeAdapter();
    repo = CategoryRepositoryImpl(CategoryRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('list maps product_count', () async {
    adapter.on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
          {'id': 'c1', 'key': 'sembako', 'name': 'Sembako', 'product_count': 3},
        ])));
    expect((await GetCategories(repo)() as Ok<List<Category>>).value, const [Category(id: 'c1', name: 'Sembako', productCount: 3)]);
  });

  test('create trims and rejects duplicates by key', () async {
    adapter.on('POST', ApiPaths.categories, (_) => FakeReply(201, envelope({'id': 'c2', 'name': 'Minuman'})));
    expect(await CreateCategory(repo)('  Minuman ', existing: existing), const Ok(Category(id: 'c2', name: 'Minuman')));
    expect(adapter.requests.single.data, {'name': 'Minuman'});
    expect(await CreateCategory(repo)(' SEMBAKO', existing: existing), const Err<Category>(ValidationFailure('category_duplicate')));
    expect(await CreateCategory(repo)('', existing: existing), const Err<Category>(ValidationFailure('required')));
  });

  test('rename ignores the category itself when checking duplicates', () async {
    adapter.on('PATCH', ApiPaths.category('c1'), (_) => FakeReply(200, envelope(null)));
    expect(await RenameCategory(repo)('c1', 'sembako', existing: existing), isA<Ok<void>>());
  });

  test('delete is blocked while products use the category', () async {
    expect(await DeleteCategory(repo)(existing.first), const Err<void>(ConflictFailure('category_in_use')));
    adapter.on('DELETE', ApiPaths.category('c9'), (_) => FakeReply(200, envelope(null)));
    expect(await DeleteCategory(repo)(const Category(id: 'c9', name: 'Kosong')), isA<Ok<void>>());
  });
}
