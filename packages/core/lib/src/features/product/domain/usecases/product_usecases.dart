import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../validation/validators.dart';
import '../entities/barcode_export.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repo);
  final ProductRepository _repo;

  Future<Result<Paged<Product>>> call(ProductQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

/// SKUs already used by the products of [categoryIds], read page by page with only the SKU kept.
/// The backend cannot search by SKU, and a SKU that repeats one already taken would overwrite
/// that product on a bulk import, so a failed page fails the whole read instead of returning a
/// list that might be missing some.
class GetTakenSkus {
  const GetTakenSkus(this._repo);
  final ProductRepository _repo;

  Future<Result<Set<String>>> call(Iterable<String> categoryIds) async {
    final taken = <String>{};
    for (final id in categoryIds.toSet()) {
      PageCursor? cursor;
      do {
        final page = await _repo.list(ProductQuery(categoryId: id), after: cursor);
        switch (page) {
          case Ok(:final value):
            taken.addAll(value.items.map((p) => p.sku));
            cursor = value.hasNext ? value.cursor : null;
          case Err(:final failure):
            return Err(failure);
        }
      } while (cursor != null);
    }
    return Ok(taken);
  }
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

class DownloadImportTemplate {
  const DownloadImportTemplate(this._repo);
  final ProductRepository _repo;

  static const fileName = 'template-produk.xlsx';

  Future<Result<List<int>>> call() => _repo.importTemplate();
}

/// Every part of the barcode sheet for [filter], each handed to [onPart] as it arrives so only
/// one part is held in memory. The first request says how many parts there are; a failed part
/// stops the export and the error is returned. Resolves to the number of parts delivered.
class ExportBarcodes {
  const ExportBarcodes(this._repo);
  final ProductRepository _repo;

  /// `X-Total-Parts` comes from the server; more parts than this is refused (50,000 products).
  static const maxParts = 100;

  Future<Result<int>> call(ProductQuery filter, Future<void> Function(BarcodeExport part) onPart) async {
    var parts = 1;
    for (var part = 1; part <= parts; part++) {
      switch (await _repo.exportBarcodes(filter, part: part)) {
        case Ok(:final value):
          if (part == 1) {
            if (value.totalParts > maxParts) return const Err(ValidationFailure('export_too_many_parts'));
            parts = value.totalParts;
          }
          await onPart(value);
        case Err(:final failure):
          return Err(failure);
      }
    }
    return Ok(parts);
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
