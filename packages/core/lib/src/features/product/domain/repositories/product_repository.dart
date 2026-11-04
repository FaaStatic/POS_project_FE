import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/barcode_export.dart';
import '../entities/product.dart';

abstract interface class ProductRepository {
  Future<Result<Paged<Product>>> list(ProductQuery query, {PageCursor? after});

  /// Every product, following pages. Used to refresh the kasir cache.
  Future<Result<List<Product>>> listAll();

  Future<Result<Product>> get(String id);
  Future<Result<Product>> update(String id, ProductPatch patch);
  Future<Result<void>> create(NewProduct product);
  Future<Result<BulkImportResult>> bulkCreate(List<NewProduct> products);

  /// .csv or .xlsx with the same columns as [ProductModel.csvHeader].
  Future<Result<BulkImportResult>> importFile(List<int> bytes, String filename);

  /// The Excel template for [importFile]: drop-downs, placeholders for the generated columns,
  /// and a guide sheet.
  Future<Result<List<int>>> importTemplate();

  /// One .xlsx (500 products at most) of barcode images for the products matching [filter];
  /// [part] starts at 1 and [BarcodeExport.totalParts] says how many there are.
  Future<Result<BarcodeExport>> exportBarcodes(ProductQuery filter, {int part = 1});

  /// [delta] is added to the current stock (negative to reduce).
  Future<Result<void>> adjustStock(String id, double delta);
  Future<Result<void>> delete(String id);
}
