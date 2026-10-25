import 'package:dio/dio.dart';

import '../../../../common/json.dart';
import '../../../../common/page.dart';
import '../../../../constants/api_paths.dart';
import '../../../../network/api_client.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  const ProductRemoteDatasource(this._api);
  final ApiClient _api;

  Future<Page<Product>> list(ProductQuery q, {PageCursor? after}) async {
    final data = readMap(await _api.get(ApiPaths.products, query: {
      'search': q.search,
      'category_id': q.categoryId,
      'barcode': q.barcode,
      'limit': q.limit,
      'last_id': after?.id,
      'after_time': after?.time,
    }));
    return Page(
      items: readList(data['product_list']).map(ProductModel.fromJson).toList(),
      cursor: PageCursor.from(data['next_id'], data['next_time']),
      hasNext: readBool(data['has_next']),
    );
  }

  Future<Product> get(String id) async => ProductModel.fromJson(readMap(await _api.get(ApiPaths.product(id))));

  /// The backend answers with `data: null`, so the fresh product is fetched again.
  Future<Product> update(String id, ProductPatch patch) async {
    await _api.patch(ApiPaths.product(id), body: ProductModel.patchToJson(patch));
    return get(id);
  }

  Future<void> create(NewProduct product) => _api.post(ApiPaths.products, body: ProductModel.newToJson(product));

  Future<BulkImportResult> bulk(List<NewProduct> products) async {
    final form = FormData.fromMap({
      'file_upload': MultipartFile.fromString(ProductModel.toCsv(products), filename: 'products.csv'),
    });
    return ProductModel.bulkResultFromJson(readMap(await _api.post(ApiPaths.productsBulk, body: form)));
  }

  Future<void> adjustStock(String id, double delta) => _api.patch(ApiPaths.productsStock, body: {'id': id, 'stock': delta});

  Future<void> delete(String id) => _api.delete(ApiPaths.product(id));
}
