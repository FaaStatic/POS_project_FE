import 'package:cms/common/file_saver.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

Map<String, dynamic> productJson() => {
      'id': 'p1',
      'sku': 'IDM-01',
      'barcode': '899',
      'product_name': 'Indomie Goreng',
      'unit': 0,
      'product_type': 0,
      'purchase_price': 2500,
      'selling_price': 3500,
      'selling_price_debt': 4000,
      'stock': 10,
      'category': 'Mie',
    };

void main() {
  CmsHarness setup() {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': [productJson()]})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
            {'id': 'c1', 'name': 'Mie', 'product_count': 1},
          ])))
      ..on('POST', ApiPaths.products, (_) => FakeReply(201, envelope(null)))
      ..on('PATCH', ApiPaths.productsStock, (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(null)))
      ..on('POST', ApiPaths.productsBulk, (_) => FakeReply(201, envelope({
            'total_inserted': 1,
            'total_updated': 0,
            'row_errors': [
              {'line': 3, 'message': 'product_name is empty'},
            ],
          })));
    return app;
  }

  testWidgets('add product posts every field; stock and delete actions', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products');
    expect(find.text('Indomie Goreng'), findsOneWidget);
    expect(find.text('10 pcs'), findsOneWidget);

    await tester.tap(find.widgetWithText(ShadButton, 'Tambah produk'));
    await tester.pumpAndSettle();
    final fields = formFields;
    await tester.enterText(fields.at(0), 'Gula 1kg');
    await tester.enterText(fields.at(1), 'GL-1');
    // Order on screen: name, SKU, barcode, category, purchase, selling, credit, stock.
    await tester.enterText(fields.at(3), 'Sembako');
    await tester.enterText(fields.at(4), '14000');
    await tester.enterText(fields.at(5), '16000');
    await tester.enterText(fields.at(6), '17000');
    await tester.enterText(fields.at(7), '5');
    await tester.ensureVisible(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Produk disimpan.'), findsOneWidget);
    await dismissInfo(tester);
    final body = app.adapter.requests.firstWhere((r) => r.method == 'POST' && r.path == ApiPaths.products).data as Map;
    expect(body, containsPair('category', 'Sembako'));
    expect(body, containsPair('selling_price_debt', 17000));

    await tester.tap(find.byTooltip('Ubah stok'));
    await tester.pumpAndSettle();
    await tester.enterText(formFields, '-2');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Stok diperbarui.'), findsOneWidget);
    await dismissInfo(tester);

    await tester.tap(find.byTooltip('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ShadButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Produk dihapus.'), findsOneWidget);
  });

  testWidgets('stock adjustment refuses a fraction of a pcs product before any request', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products');
    await tester.tap(find.byTooltip('Ubah stok'));
    await tester.pumpAndSettle();
    await tester.enterText(formFields, '2.5');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Satuan pcs harus bilangan bulat.'), findsOneWidget);
    expect(app.adapter.requests.where((r) => r.method == 'PATCH'), isEmpty);

    await tester.enterText(formFields, '-2');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.where((r) => r.method == 'PATCH'), hasLength(1));
  });

  testWidgets('export barcodes saves every part for the filter on screen', (tester) async {
    final app = setup();
    app.adapter.on('GET', ApiPaths.productsExportBarcodes, (_) => const FakeReply(200, [80, 75], {'x-total-parts': '2'}));
    await app.pump(tester, location: '/products');
    await tester.tap(find.text('Ekspor barcode'));
    await tester.pumpAndSettle();
    expect(savedFiles.sublist(savedFiles.length - 2), ['barcode-produk-part-1-of-2.xlsx', 'barcode-produk-part-2-of-2.xlsx']);
    expect(app.adapter.requests.where((r) => r.path == ApiPaths.productsExportBarcodes).map((r) => r.queryParameters['part']), [1, 2]);
  });

  for (final (name, size, scale) in [('desktop dialog', const Size(1280, 900), 1.0), ('phone page', const Size(360, 780), 1.0), ('phone at 200% text', const Size(360, 780), 2.0)]) {
    testWidgets('product form groups its fields and fits a $name', (tester) async {
      final app = setup();
      await app.pump(tester, location: '/products', size: size, textScale: scale);
      final add = find.widgetWithText(ShadButton, 'Tambah produk');
      await tester.ensureVisible(add);
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (final title in ['Informasi produk', 'Harga', 'Stok dan gambar']) {
        expect(find.text(title), findsOneWidget);
      }
      expect(find.text('Rp'), findsNWidgets(3));
    });
  }

  testWidgets('bulk add sends filled rows as CSV and shows per-row errors', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products/bulk');
    final fields = formFields;
    // Order on screen: name, SKU, barcode, category, then purchase, selling, credit price, stock.
    for (final (i, v) in ['Kopi', 'A1', '', 'Minuman', '1000', '1500', '1600', '3'].indexed) {
      await tester.enterText(fields.at(i), v);
    }
    await tester.scrollUntilVisible(find.text('Simpan semua'), 200, scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan semua'));
    await tester.pumpAndSettle();
    expect(find.text('1 ditambahkan, 0 diperbarui.'), findsOneWidget);
    expect(find.text('Baris 2: product_name is empty'), findsOneWidget);
    final form = app.adapter.requests.firstWhere((r) => r.path == ApiPaths.productsBulk).data as FormData;
    expect(form.files.single.value.filename, 'products.csv');
  });

  testWidgets('bulk add validates partially filled rows', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products/bulk', size: const Size(800, 900));
    await tester.enterText(formFields.at(2), 'Kopi');
    await tester.scrollUntilVisible(find.text('Simpan semua'), 200, scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan semua'));
    await tester.pumpAndSettle();
    expect(find.text('Wajib diisi'), findsWidgets);
    expect(app.adapter.requests.where((r) => r.path == ApiPaths.productsBulk), isEmpty);
  });

  testWidgets('products list as cards on a phone', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products', size: const Size(390, 820));
    expect(find.byType(Card), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

