import '../../../../common/guard.dart';
import '../../../../common/json.dart';
import '../../../../common/result.dart';
import '../../../../constants/api_paths.dart';
import '../../../../network/api_client.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

Category categoryFromJson(Map<String, dynamic> j) =>
    Category(id: readString(j['id']), name: readString(j['name']), productCount: readInt(j['product_count']));

class CategoryRemoteDatasource {
  const CategoryRemoteDatasource(this._api);
  final ApiClient _api;

  Future<List<Category>> list() async => readList(await _api.get(ApiPaths.categories)).map(categoryFromJson).toList();
  Future<Category> create(String name) async => categoryFromJson(readMap(await _api.post(ApiPaths.categories, body: {'name': name})));
  Future<void> rename(String id, String name) => _api.patch(ApiPaths.category(id), body: {'name': name});
  Future<void> delete(String id) => _api.delete(ApiPaths.category(id));
}

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remote);
  final CategoryRemoteDatasource _remote;

  @override
  Future<Result<List<Category>>> list() => guard(_remote.list);
  @override
  Future<Result<Category>> create(String name) => guard(() => _remote.create(name));
  @override
  Future<Result<void>> rename(String id, String name) => guard(() => _remote.rename(id, name));
  @override
  Future<Result<void>> delete(String id) => guard(() => _remote.delete(id));
}
