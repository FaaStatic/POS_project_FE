/// One .xlsx of product barcodes. The backend puts at most 500 products in a file and reports
/// in `X-Total-Parts` how many files the filter needs.
class BarcodeExport {
  const BarcodeExport({required this.part, required this.totalParts, required this.bytes});

  final int part;
  final int totalParts;
  final List<int> bytes;

  String get fileName => 'barcode-produk-part-$part-of-$totalParts.xlsx';
}
