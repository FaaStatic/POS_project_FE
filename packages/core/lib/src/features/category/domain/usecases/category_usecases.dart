import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../../../../validation/validators.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._repo);
  final CategoryRepository _repo;

  Future<Result<List<Category>>> call() => _repo.list();
}

class CreateCategory {
  const CreateCategory(this._repo);
  final CategoryRepository _repo;

  Future<Result<Category>> call(String name, {List<Category> existing = const []}) {
    final error = Validators.categoryName(name) ?? _duplicate(name, existing);
    if (error != null) return Future.value(Err(ValidationFailure(error)));
    return _repo.create(name.trim());
  }
}

class RenameCategory {
  const RenameCategory(this._repo);
  final CategoryRepository _repo;

  Future<Result<void>> call(String id, String name, {List<Category> existing = const []}) {
    final others = existing.where((c) => c.id != id).toList();
    final error = Validators.categoryName(name) ?? _duplicate(name, others);
    if (error != null) return Future.value(Err(ValidationFailure(error)));
    return _repo.rename(id, name.trim());
  }
}

class DeleteCategory {
  const DeleteCategory(this._repo);
  final CategoryRepository _repo;

  Future<Result<void>> call(Category category) {
    if (category.productCount > 0) return Future.value(const Err(ConflictFailure('category_in_use')));
    return _repo.delete(category.id);
  }
}

/// Backend uniqueness rule: key = lower(trim(name)).
String? _duplicate(String name, List<Category> existing) {
  final key = Validators.categoryKey(name);
  return existing.any((c) => Validators.categoryKey(c.name) == key) ? 'category_duplicate' : null;
}
