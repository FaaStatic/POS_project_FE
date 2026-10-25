import '../../../../common/json.dart';
import '../../domain/entities/product.dart';

/// `GET /api/products` item (ProductDtoResponse).
abstract final class ProductModel {
  static Product fromJson(Map<String, dynamic> j) => Product(
        id: readString(j['id']),
        sku: readString(j['sku']),
        barcode: readNullableString(j['barcode']),
        name: readString(j['product_name']),
        unit: _enumAt(ProductUnit.values, readInt(j['unit'])),
        type: _enumAt(ProductType.values, readInt(j['product_type'])),
        purchasePrice: readInt(j['purchase_price']),
        sellingPrice: readInt(j['selling_price']),
        sellingPriceDebt: readInt(j['selling_price_debt']),
        stock: readDouble(j['stock']),
        categoryId: readNullableString(j['category_id']),
        categoryName: readString(j['category']),
        image: readString(j['image']),
        updatedAt: readDate(j['updated_at']),
      );

  static Map<String, dynamic> patchToJson(ProductPatch p) => {
        'sku': ?p.sku,
        'barcode': ?p.barcode,
        'product_name': ?p.name,
        'unit': ?p.unit?.index,
        'selling_price': ?p.sellingPrice,
        'selling_price_debt': ?p.sellingPriceDebt,
        'category': ?p.category,
        'image': ?p.image,
        'purchase_price': ?p.purchasePrice,
        'product_type': ?p.type?.index,
      };

  static Map<String, dynamic> newToJson(NewProduct p) => {
        'sku': p.sku,
        if (p.barcode.isNotEmpty) 'barcode': p.barcode,
        'product_name': p.name,
        'unit': p.unit.index,
        'product_type': p.type.index,
        'purchase_price': p.purchasePrice,
        'selling_price': p.sellingPrice,
        'selling_price_debt': p.sellingPriceDebt,
        'stock': p.stock,
        'category': p.category,
        if (p.image.isNotEmpty) 'image': p.image,
      };

  static const csvHeader = [
    'sku',
    'barcode',
    'product_name',
    'unit',
    'purchase_price',
    'selling_price',
    'selling_price_debt',
    'stock',
    'category',
    'image',
    'product_type',
  ];

  /// CSV accepted by `POST /api/products/bulk` (pkg/sheet/product_sheet.go).
  static String toCsv(List<NewProduct> products) {
    final rows = [
      csvHeader,
      for (final p in products)
        [
          p.sku,
          p.barcode,
          p.name,
          p.unit.name,
          '${p.purchasePrice}',
          '${p.sellingPrice}',
          '${p.sellingPriceDebt}',
          _num(p.stock),
          p.category,
          p.image,
          p.type == ProductType.digital ? 'digital' : 'physical',
        ],
    ];
    return rows.map((r) => r.map(_csvCell).join(',')).join('\r\n');
  }

  static BulkImportResult bulkResultFromJson(Map<String, dynamic> j) => BulkImportResult(
        inserted: readInt(j['total_inserted']),
        updated: readInt(j['total_updated']),
        duplicateInFile: (j['duplicate_in_file'] as List?)?.map((e) => '$e').toList() ?? const [],
        rowErrors: [
          for (final e in readList(j['row_errors'])) (line: readInt(e['line']), message: readString(e['message'])),
        ],
      );

  static T _enumAt<T>(List<T> values, int index) => index >= 0 && index < values.length ? values[index] : values.first;

  static String _num(double v) => v == v.roundToDouble() ? '${v.round()}' : '$v';

  static String _csvCell(String v) =>
      v.contains(RegExp('[",\r\n]')) ? '"${v.replaceAll('"', '""')}"' : v;
}
