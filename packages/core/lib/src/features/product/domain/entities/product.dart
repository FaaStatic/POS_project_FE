import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// Backend `unit` enum order: pcs, gram, kg, liter, kardus, ikat.
enum ProductUnit { pcs, gram, kg, liter, kardus, ikat }

/// Digital products (pulsa, e-wallet, data) need a destination number per line.
enum ProductType { physical, digital }

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String sku,
    String? barcode,
    required String name,
    @Default(ProductUnit.pcs) ProductUnit unit,
    @Default(ProductType.physical) ProductType type,
    @Default(0) int purchasePrice,
    required int sellingPrice,
    required int sellingPriceDebt,
    @Default(0) double stock,
    String? categoryId,
    @Default('') String categoryName,
    @Default('') String image,
    DateTime? updatedAt,
  }) = _Product;

  bool get isDigital => type == ProductType.digital;
}

/// Fields a cashier may change. Null means unchanged. [barcode] "" clears it.
@freezed
abstract class ProductPatch with _$ProductPatch {
  const factory ProductPatch({
    String? sku,
    String? barcode,
    String? name,
    ProductUnit? unit,
    int? sellingPrice,
    int? sellingPriceDebt,
    String? category,
    String? image,
    // Superadmin only; the backend rejects these from staff.
    int? purchasePrice,
    ProductType? type,
  }) = _ProductPatch;
}

@freezed
abstract class NewProduct with _$NewProduct {
  const factory NewProduct({
    required String sku,
    @Default('') String barcode,
    required String name,
    @Default(ProductUnit.pcs) ProductUnit unit,
    @Default(ProductType.physical) ProductType type,
    required int purchasePrice,
    required int sellingPrice,
    required int sellingPriceDebt,
    required double stock,
    required String category,
    @Default('') String image,
  }) = _NewProduct;
}

class ProductQuery {
  const ProductQuery({this.search, this.categoryId, this.barcode, this.limit = 100});
  final String? search;
  final String? categoryId;
  final String? barcode;
  final int limit;
}

class BulkImportResult {
  const BulkImportResult({
    required this.inserted,
    required this.updated,
    this.duplicateInFile = const [],
    this.rowErrors = const [],
  });

  final int inserted;
  final int updated;
  final List<String> duplicateInFile;
  final List<({int line, String message})> rowErrors;
}
