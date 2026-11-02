import 'dart:convert';

import 'package:cms/common/file_picker.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

Map<String, dynamic> _product({String image = ''}) => {
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
      'image': image,
    };

CmsHarness _setup({String image = ''}) {
  final app = CmsHarness();
  app.adapter
    ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': [_product(image: image)]})))
    ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
          {'id': 'c1', 'name': 'Mie', 'product_count': 1},
        ])))
    ..on('POST', ApiPaths.products, (_) => FakeReply(201, envelope(null)))
    ..on('PATCH', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(_product())))
    ..on('POST', ApiPaths.productsBulk, (_) => FakeReply(201, envelope({'total_inserted': 1, 'total_updated': 0, 'row_errors': []})));
  return app;
}

Map<dynamic, dynamic> _body(CmsHarness app, String method, String path) =>
    app.adapter.requests.firstWhere((r) => r.method == method && r.path == path).data as Map;

Future<void> _openAdd(WidgetTester tester, CmsHarness app) async {
  await app.pump(tester, location: '/products', size: const Size(1280, 1000));
  await tester.tap(find.widgetWithText(ShadButton, 'Tambah produk'));
  await tester.pumpAndSettle();
}

Future<void> _pick(WidgetTester tester, String name, List<int> bytes) async {
  debugPickedFile = PickedFile(name, bytes);
  final button = find.text('Pilih gambar');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> _fillRequired(WidgetTester tester) async {
  // Order on screen: name, SKU, barcode, category, purchase, selling, credit price, stock.
  final fields = formFields;
  for (final (i, v) in ['Gula 1kg', 'GL-1', '', 'Mie', '14000', '16000', '17000', '5'].indexed) {
    await tester.enterText(fields.at(i), v);
  }
}

Future<void> _save(WidgetTester tester) async {
  await tester.ensureVisible(find.widgetWithText(ShadButton, 'Simpan'));
  await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => debugPickedFile = null);

  group('product form', () {
    testWidgets('shows the rules and no URL field', (tester) async {
      await _openAdd(tester, _setup());
      expect(find.text('Gambar produk (opsional)'), findsOneWidget);
      expect(find.text('WebP, rasio 1:1, maks 500 KB'), findsOneWidget);
      expect(find.text('URL gambar (opsional)'), findsNothing);
    });

    testWidgets('a valid WebP is sent to the backend as raw base64', (tester) async {
      final app = _setup();
      await _openAdd(tester, app);
      await _fillRequired(tester);
      await _pick(tester, 'gula.webp', square64);
      expect(find.text('gula.webp'), findsOneWidget);
      await _save(tester);

      final image = _body(app, 'POST', ApiPaths.products)['image'] as String;
      expect(image, square64Base64);
      expect(base64Decode(image), square64);
      expect(image, isNot(contains('data:')));
    });

    testWidgets('a PNG is refused as not WebP and nothing is sent for the image', (tester) async {
      final app = _setup();
      await _openAdd(tester, app);
      await _fillRequired(tester);
      await _pick(tester, 'gula.png', pngBytes);
      expect(find.text('Gambar harus berformat WebP.'), findsOneWidget);
      await _save(tester);

      expect(_body(app, 'POST', ApiPaths.products).containsKey('image'), isFalse);
    });

    testWidgets('a WebP that is not 1:1 is refused', (tester) async {
      await _openAdd(tester, _setup());
      await _pick(tester, 'lebar.webp', wide100x60);
      expect(find.text('Gambar harus persegi (rasio 1:1).'), findsOneWidget);
      expect(find.text('lebar.webp'), findsNothing);
    });

    testWidgets('over 500 KB is refused, exactly 500 KB is accepted', (tester) async {
      final app = _setup();
      await _openAdd(tester, app);
      await _pick(tester, 'besar.webp', squareWebpOfSize(500 * 1024 + 1));
      expect(find.text('Ukuran gambar maksimal 500 KB.'), findsOneWidget);

      await _pick(tester, 'pas.webp', squareWebpOfSize(500 * 1024));
      expect(find.text('Ukuran gambar maksimal 500 KB.'), findsNothing);
      expect(find.text('pas.webp'), findsOneWidget);
    });

    testWidgets('editing: a stored base64 picture is previewed, and a new pick patches only the image', (tester) async {
      final app = _setup(image: square64Base64);
      await app.pump(tester, location: '/products', size: const Size(1280, 1000));
      await tester.tap(find.byTooltip('Aksi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ubah'));
      await tester.pumpAndSettle();
      expect(find.text('Ganti gambar'), findsOneWidget);

      await tester.ensureVisible(find.text('Ganti gambar'));
      debugPickedFile = PickedFile('baru.webp', squareWebpOfSize(square64.length + 10));
      await tester.tap(find.text('Ganti gambar'));
      await tester.pumpAndSettle();
      await _save(tester);

      final patch = _body(app, 'PATCH', ApiPaths.product('p1'));
      expect(patch.keys, ['image']);
      expect(patch['image'], base64Encode(squareWebpOfSize(square64.length + 10)));
    });

    testWidgets('editing: removing the picture clears it on the backend', (tester) async {
      final app = _setup(image: square64Base64);
      await app.pump(tester, location: '/products', size: const Size(1280, 1000));
      await tester.tap(find.byTooltip('Aksi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ubah'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Hapus gambar'));
      await tester.tap(find.text('Hapus gambar'));
      await tester.pumpAndSettle();
      await _save(tester);

      expect(_body(app, 'PATCH', ApiPaths.product('p1')), {'image': ''});
    });
  });

  group('bulk add', () {
    testWidgets('each row takes a picture and the CSV carries it as base64', (tester) async {
      final app = _setup();
      await app.pump(tester, location: '/products/bulk', size: const Size(1280, 1000));
      expect(find.text('Gambar produk (opsional)'), findsNWidgets(3));

      final fields = formFields;
      for (final (i, v) in ['Kopi', 'A1', '', 'Minuman', '1000', '1500', '1600', '3'].indexed) {
        await tester.enterText(fields.at(i), v);
      }
      debugPickedFile = PickedFile('kopi.webp', square64);
      await tester.ensureVisible(find.text('Pilih gambar').first);
      await tester.tap(find.text('Pilih gambar').first);
      await tester.pumpAndSettle();
      expect(find.text('kopi.webp'), findsOneWidget);

      await tester.tap(find.widgetWithText(ShadButton, 'Simpan semua'));
      await tester.pumpAndSettle();

      // The multipart body holds the CSV as text, with the picture as raw base64 in its image column.
      final body = app.adapter.streamedBodies.map(utf8.decode).singleWhere((b) => b.contains('products.csv'));
      expect(body, contains(',$square64Base64'));
      expect(body, isNot(contains('data:image')));
    });

    testWidgets('a refused picture shows its reason on that row only', (tester) async {
      await _setup().pump(tester, location: '/products/bulk', size: const Size(1280, 1000));
      debugPickedFile = PickedFile('lebar.webp', wide100x60);
      await tester.ensureVisible(find.text('Pilih gambar').first);
      await tester.tap(find.text('Pilih gambar').first);
      await tester.pumpAndSettle();
      expect(find.text('Gambar harus persegi (rasio 1:1).'), findsOneWidget);
    });

    testWidgets('a row with only a picture is still validated as a product', (tester) async {
      final app = _setup();
      await app.pump(tester, location: '/products/bulk', size: const Size(1280, 1000));
      debugPickedFile = PickedFile('kopi.webp', square64);
      await tester.ensureVisible(find.text('Pilih gambar').first);
      await tester.tap(find.text('Pilih gambar').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ShadButton, 'Simpan semua'));
      await tester.pumpAndSettle();

      expect(app.adapter.requests.where((r) => r.path == ApiPaths.productsBulk), isEmpty, reason: 'name, SKU, and prices are missing');
    });
  });
}
