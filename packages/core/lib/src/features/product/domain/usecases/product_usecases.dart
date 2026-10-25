import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../validation/validators.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repo);
  final ProductRepository _repo;

  Future<Result<Paged<Product>>> call(ProductQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

class GetAllProducts {
  const GetAllProducts(this._repo);
  final ProductRepository _repo;

  Future<Result<List<Product>>> call() => _repo.listAll();
}

class GetProduct {
  const GetProduct(this._repo);
  final ProductRepository _repo;

  Future<Result<Product>> call(String id) => _repo.get(id);
}

class UpdateProduct {
  const UpdateProduct(this._repo);
  final ProductRepository _repo;

  Future<Result<Product>> call(String id, ProductPatch patch) {
    final barcode = patch.barcode;
    if (barcode != null && Validators.barcode(barcode) != null) {
      return Future.value(const Err(ValidationFailure('barcode_format')));
    }
    return _repo.update(id, patch);
  }
}

/// Attach a scanned, unknown barcode to an existing product.
class AssignBarcode {
  const AssignBarcode(this._update);
  final UpdateProduct _update;

  Future<Result<Product>> call(String productId, String barcode) =>
      _update(productId, ProductPatch(barcode: barcode.trim()));
}

class CreateProduct {
  const CreateProduct(this._repo);
  final ProductRepository _repo;

  Future<Result<void>> call(NewProduct product) => _repo.create(product);
}

class BulkCreateProducts {
  const BulkCreateProducts(this._repo);
  final ProductRepository _repo;

  Future<Result<BulkImportResult>> call(List<NewProduct> products) {
    if (products.isEmpty) return Future.value(const Err(ValidationFailure('empty')));
    return _repo.bulkCreate(products);
  }
}

/// Backend limits: .csv or .xlsx, up to 10,000 rows, 25 MB request body.
class ImportProductsFile {
  const ImportProductsFile(this._repo);
  final ProductRepository _repo;

  static const maxBytes = 25 * 1024 * 1024;
  static const extensions = ['.csv', '.xlsx'];

  Future<Result<BulkImportResult>> call(List<int> bytes, String filename) {
    final name = filename.toLowerCase();
    if (!extensions.any(name.endsWith)) return Future.value(const Err(ValidationFailure('import_format')));
    if (bytes.isEmpty) return Future.value(const Err(ValidationFailure('import_empty')));
    if (bytes.length > maxBytes) return Future.value(const Err(ValidationFailure('import_too_large')));
    return _repo.importFile(bytes, filename);
  }
}

class AdjustStock {
  const AdjustStock(this._repo);
  final ProductRepository _repo;

  Future<Result<void>> call(String id, double delta) {
    if (delta == 0) return Future.value(const Err(ValidationFailure('zero_delta')));
    return _repo.adjustStock(id, delta);
  }
}

class DeleteProduct {
  const DeleteProduct(this._repo);
  final ProductRepository _repo;

  Future<Result<void>> call(String id) => _repo.delete(id);
}
