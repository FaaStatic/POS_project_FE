import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../../../category/domain/repositories/category_repository.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../repositories/catalog_cache.dart';

/// Pulls products, categories, and customers from the server into the cache.
/// Each part is applied independently so one failing list does not block the others.
class RefreshCatalog {
  const RefreshCatalog(this._products, this._categories, this._customers, this._cache);
  final ProductRepository _products;
  final CategoryRepository _categories;
  final CustomerRepository _customers;
  final CatalogCache _cache;

  Future<Result<void>> call() async {
    final (products, categories, customers) =
        await (_products.listAll(), _categories.list(), _customers.listAll()).wait;
    Failure? failure;
    switch (products) {
      case Ok(:final value):
        await _cache.replaceProducts(value);
      case Err(failure: final f):
        failure = f;
    }
    switch (categories) {
      case Ok(:final value):
        await _cache.replaceCategories(value);
      case Err(failure: final f):
        failure ??= f;
    }
    switch (customers) {
      case Ok(:final value):
        await _cache.replaceCustomers(value);
      case Err(failure: final f):
        failure ??= f;
    }
    return failure == null ? const Ok(null) : Err(failure);
  }
}
