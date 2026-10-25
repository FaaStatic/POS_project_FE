import '../../../../common/result.dart';
import '../entities/category.dart';

abstract interface class CategoryRepository {
  Future<Result<List<Category>>> list();
  Future<Result<Category>> create(String name);
  Future<Result<void>> rename(String id, String name);

  /// Fails with ConflictFailure while products still use the category.
  Future<Result<void>> delete(String id);
}
