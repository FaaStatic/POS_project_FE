import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

    await tester.tap(find.widgetWithText(FilledButton, 'Tambah produk'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Gula 1kg');
    await tester.enterText(fields.at(1), 'GL-1');
    await tester.enterText(fields.at(3), '14000');
    await tester.enterText(fields.at(4), '16000');
    await tester.enterText(fields.at(5), '17000');
    await tester.enterText(fields.at(6), '5');
    await tester.enterText(fields.at(7), 'Sembako');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Produk disimpan.'), findsOneWidget);
    final body = app.adapter.requests.firstWhere((r) => r.method == 'POST' && r.path == ApiPaths.products).data as Map;
    expect(body, containsPair('category', 'Sembako'));
    expect(body, containsPair('selling_price_debt', 17000));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah stok'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '-2');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Stok diperbarui.'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Produk dihapus.'), findsOneWidget);
  });

  testWidgets('bulk add sends filled rows as CSV and shows per-row errors', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products/bulk');
    final fields = find.byType(TextFormField);
    for (final (i, v) in ['A1', '', 'Kopi', '1000', '1500', '1600', '3', 'Minuman'].indexed) {
      await tester.enterText(fields.at(i), v);
    }
    await tester.scrollUntilVisible(find.text('Simpan semua'), 200, scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan semua'));
    await tester.pumpAndSettle();
    expect(find.text('1 ditambahkan, 0 diperbarui.'), findsOneWidget);
    expect(find.text('Baris 2: product_name is empty'), findsOneWidget);
    final form = app.adapter.requests.firstWhere((r) => r.path == ApiPaths.productsBulk).data as FormData;
    expect(form.files.single.value.filename, 'products.csv');
  });

  testWidgets('bulk add validates partially filled rows', (tester) async {
    final app = setup();
    await app.pump(tester, location: '/products/bulk', size: const Size(800, 900));
    await tester.enterText(find.byType(TextFormField).at(2), 'Kopi');
    await tester.scrollUntilVisible(find.text('Simpan semua'), 200, scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan semua'));
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

