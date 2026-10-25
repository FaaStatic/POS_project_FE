import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAdapter adapter;
  late ImportProductsFile importFile;

  setUp(() {
    adapter = FakeAdapter()
      ..on('POST', ApiPaths.productsBulk, (o) {
        final file = (o.data as FormData).files.single;
        expect(file.key, 'file_upload');
        expect(file.value.filename, 'produk.xlsx');
        return FakeReply(201, envelope({'total_inserted': 3, 'total_updated': 1}));
      });
    importFile = ImportProductsFile(ProductRepositoryImpl(ProductRemoteDatasource(ApiClient(fakeDio(adapter)))));
  });

  test('uploads the file unchanged under file_upload', () async {
    final r = (await importFile(const [1, 2, 3], 'produk.xlsx') as Ok<BulkImportResult>).value;
    expect([r.inserted, r.updated], [3, 1]);
  });

  test('rejects other formats, empty files, and files over 25 MB before uploading', () async {
    expect(await importFile(const [1], 'produk.xls'), const Err<BulkImportResult>(ValidationFailure('import_format')));
    expect(await importFile(const [], 'produk.csv'), const Err<BulkImportResult>(ValidationFailure('import_empty')));
    expect(await importFile(List.filled(ImportProductsFile.maxBytes + 1, 0), 'p.CSV'), const Err<BulkImportResult>(ValidationFailure('import_too_large')));
    expect(adapter.requests, isEmpty);
  });
}
