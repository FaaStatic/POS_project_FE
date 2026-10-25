import 'package:cms/common/file_picker.dart';
import 'package:cms/common/file_saver.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cms_harness.dart';

void main() {
  tearDown(() => debugPickedFile = null);

  testWidgets('picks an .xlsx, uploads it as file_upload, and shows the report', (tester) async {
    final app = CmsHarness();
    app.adapter.on('POST', ApiPaths.productsBulk, (o) => FakeReply(201, envelope({
          'total_inserted': 120,
          'total_updated': 4,
          'row_errors': [
            {'line': 7, 'message': 'invalid unit'},
          ],
        })));
    debugPickedFile = const PickedFile('produk.xlsx', [80, 75, 3, 4]);
    await app.pump(tester, location: '/products/bulk');
    await tester.tap(find.text('Pilih file .xlsx atau .csv'));
    await tester.pumpAndSettle();
    expect(find.text('120 ditambahkan, 4 diperbarui.'), findsOneWidget);
    expect(find.text('Baris 6: invalid unit'), findsOneWidget);
    final form = app.adapter.requests.firstWhere((r) => r.path == ApiPaths.productsBulk).data as FormData;
    expect(form.files.single.value.filename, 'produk.xlsx');
  });

  testWidgets('wrong format is refused without uploading; template downloads', (tester) async {
    final app = CmsHarness();
    debugPickedFile = const PickedFile('produk.xls', [1]);
    await app.pump(tester, location: '/products/bulk');
    await tester.tap(find.text('Pilih file .xlsx atau .csv'));
    await tester.pumpAndSettle();
    expect(find.text('Hanya file .xlsx atau .csv.'), findsOneWidget);
    expect(app.adapter.requests.where((r) => r.path == ApiPaths.productsBulk), isEmpty);
    await tester.tap(find.text('Unduh template CSV'));
    expect(savedFiles.last, 'template-produk.csv');
  });

  testWidgets('cancelling the file dialog does nothing', (tester) async {
    final app = CmsHarness();
    await app.pump(tester, location: '/products/bulk', size: const Size(390, 800));
    await tester.tap(find.text('Pilih file .xlsx atau .csv'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.where((r) => r.path == ApiPaths.productsBulk), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
