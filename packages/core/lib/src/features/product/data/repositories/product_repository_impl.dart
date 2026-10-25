import '../../../../common/guard.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote);
  final ProductRemoteDatasource _remote;

  @override
  Future<Result<Paged<Product>>> list(ProductQuery query, {PageCursor? after}) =>
      guard(() => _remote.list(query, after: after));

  @override
  Future<Result<List<Product>>> listAll() => guard(() async {
        final all = <Product>[];
        PageCursor? cursor;
        do {
          final page = await _remote.list(const ProductQuery(), after: cursor);
          all.addAll(page.items);
          cursor = page.hasNext ? page.cursor : null;
        } while (cursor != null);
        return all;
      });

  @override
  Future<Result<Product>> get(String id) => guard(() => _remote.get(id));

  @override
  Future<Result<Product>> update(String id, ProductPatch patch) => guard(() => _remote.update(id, patch));

  @override
  Future<Result<void>> create(NewProduct product) => guard(() => _remote.create(product));

  @override
  Future<Result<BulkImportResult>> bulkCreate(List<NewProduct> products) => guard(() => _remote.bulk(products));

  @override
  Future<Result<void>> adjustStock(String id, double delta) => guard(() => _remote.adjustStock(id, delta));

  @override
  Future<Result<void>> delete(String id) => guard(() => _remote.delete(id));
}
