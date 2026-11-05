import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

Map<String, dynamic> _product(String id, String sku, {String category = 'Mie Instan', String categoryId = 'c1'}) => {
      'id': id,
      'sku': sku,
      'barcode': null,
      'product_name': 'Produk $id',
      'unit': 0,
      'product_type': 0,
      'purchase_price': 2500,
      'selling_price': 3500,
      'selling_price_debt': 4000,
      'stock': 10,
      'category_id': categoryId,
      'category': category,
    };

/// A store with two categories that share the code MIN, and Mie Instan with one SKU taken.
CmsHarness _setup({List<String> mieSkus = const ['MIE-P-IG-001'], bool takenFails = false, List<FakeReply Function()>? posts}) {
  final app = CmsHarness();
  app.adapter
    ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
          {'id': 'c1', 'name': 'Mie Instan', 'product_count': 1},
          {'id': 'c2', 'name': 'Minuman', 'product_count': 1},
          {'id': 'c3', 'name': 'Minyak Goreng', 'product_count': 1},
        ])))
    ..on('GET', ApiPaths.products, (o) {
      final categoryId = o.queryParameters['category_id'];
      if (categoryId == null) {
        return FakeReply(200, envelope({'product_list': [_product('p1', mieSkus.first)]}));
      }
      if (takenFails) return FakeReply(500, errorBody('down'));
      return FakeReply(200, envelope({
        'product_list': switch (categoryId) {
          'c1' => [for (final (i, s) in mieSkus.indexed) _product('m$i', s)],
          'c2' => [_product('n1', 'MIN-P-TP-001', category: 'Minuman', categoryId: 'c2')],
          'c3' => [_product('y1', 'MIN-P-TP-002', category: 'Minyak Goreng', categoryId: 'c3')],
          _ => [],
        },
      }));
    })
    ..on('POST', ApiPaths.products, (_) => posts == null ? FakeReply(201, envelope(null)) : posts.removeAt(0)())
    ..on('POST', ApiPaths.productsBulk, (_) => FakeReply(201, envelope({'total_inserted': 3, 'total_updated': 0, 'row_errors': []})));
  return app;
}

Future<void> _openAdd(WidgetTester tester, CmsHarness app) async {
  await app.pump(tester, location: '/products', size: const Size(1280, 1100));
  await tester.tap(find.widgetWithText(ShadButton, 'Tambah produk'));
  await tester.pumpAndSettle();
}

/// The SKU follows edits after a short pause, so wait that out before reading it.
Future<void> _settleSku(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

// On screen: name, SKU, barcode, category, purchase, selling, credit price, stock.
String _text(WidgetTester tester, int field) => tester.widget<EditableText>(formFields.at(field)).controller.text;
String _sku(WidgetTester tester) => _text(tester, 1);

Future<void> _type(WidgetTester tester, int field, String text) async {
  await tester.enterText(formFields.at(field), text);
  await _settleSku(tester);
}

Map<dynamic, dynamic> _posted(CmsHarness app, {int index = 0}) =>
    app.adapter.requests.where((r) => r.method == 'POST' && r.path == ApiPaths.products).toList()[index].data as Map;

Future<void> _fillRest(WidgetTester tester) async {
  for (final (i, v) in [(4, '14000'), (5, '16000'), (6, '17000'), (7, '5')]) {
    await tester.enterText(formFields.at(i), v);
  }
}

Future<void> _save(WidgetTester tester) async {
  await tester.ensureVisible(find.widgetWithText(ShadButton, 'Simpan'));
  await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
  await tester.pumpAndSettle();
}

void main() {
  group('SKU for a new product', () {
    testWidgets('shows how it is made while there is nothing to make it from', (tester) async {
      await _openAdd(tester, _setup());
      expect(find.text('Otomatis dari kategori, tipe, dan nama'), findsOneWidget);
      expect(_sku(tester), isEmpty);
    });

    testWidgets('fills in from category, type, name acronym, and the next number', (tester) async {
      await _openAdd(tester, _setup());
      await _type(tester, 0, 'Indomie Goreng');
      expect(_sku(tester), isEmpty, reason: 'no category yet');

      await _type(tester, 3, 'Mie Instan');
      expect(_sku(tester), 'MIE-P-IG-002', reason: 'MIE-P-IG-001 is already taken');
    });

    testWidgets('follows the name while it is edited', (tester) async {
      await _openAdd(tester, _setup(mieSkus: ['MIE-P-IG-001', 'MIE-P-SG-001']));
      await _type(tester, 3, 'Mie Instan');
      await _type(tester, 0, 'Indomie Goreng');
      expect(_sku(tester), 'MIE-P-IG-002');
      await _type(tester, 0, 'Sedaap Goreng');
      expect(_sku(tester), 'MIE-P-SG-002');
    });

    testWidgets('a digital product gets a D', (tester) async {
      await _openAdd(tester, _setup(mieSkus: ['IDM-01']));
      await _type(tester, 0, 'Indomie Goreng');
      await _type(tester, 3, 'Mie Instan');
      expect(_sku(tester), 'MIE-P-IG-001');

      await tester.tap(find.text('Fisik'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Digital').last);
      await _settleSku(tester);
      expect(_sku(tester), 'MIE-D-IG-001');
    });

    testWidgets('a category that shares a code with another counts both', (tester) async {
      await _openAdd(tester, _setup());
      await _type(tester, 0, 'Teh Pucuk');
      await _type(tester, 3, 'Minuman');
      expect(_sku(tester), 'MIN-P-TP-003', reason: 'Minuman holds 001 and Minyak Goreng holds 002, both MIN');
    });

    testWidgets('a typed SKU is left alone, and clearing it hands it back', (tester) async {
      await _openAdd(tester, _setup(mieSkus: ['IDM-01']));
      await _type(tester, 3, 'Mie Instan');
      await _type(tester, 1, 'MANUAL-1');
      await _type(tester, 0, 'Indomie Goreng');
      expect(_sku(tester), 'MANUAL-1');

      await _type(tester, 1, '');
      expect(_sku(tester), 'MIE-P-IG-001');
    });

    testWidgets('is empty, and can be typed, when the existing SKUs cannot be read', (tester) async {
      final app = _setup(takenFails: true);
      await _openAdd(tester, app);
      await _type(tester, 0, 'Indomie Goreng');
      await _type(tester, 3, 'Mie Instan');
      expect(_sku(tester), isEmpty);

      await _type(tester, 1, 'IDM-9');
      await _fillRest(tester);
      await _save(tester);
      expect(_posted(app)['sku'], 'IDM-9');
    });

    testWidgets('is the SKU that is sent', (tester) async {
      final app = _setup(mieSkus: ['IDM-01']);
      await _openAdd(tester, app);
      await _type(tester, 0, 'Indomie Goreng');
      await _type(tester, 3, 'Mie Instan');
      await _fillRest(tester);
      await _save(tester);
      expect(_posted(app)['sku'], 'MIE-P-IG-001');
    });

    testWidgets('when the backend says it was just taken, the next number is tried', (tester) async {
      final app = _setup(
        mieSkus: ['IDM-01'],
        posts: [() => FakeReply(409, errorBody('product with sku MIE-P-IG-001 or the same barcode already exists')), () => FakeReply(201, envelope(null))],
      );
      await _openAdd(tester, app);
      await _type(tester, 0, 'Indomie Goreng');
      await _type(tester, 3, 'Mie Instan');
      await _fillRest(tester);
      await _save(tester);

      expect(_posted(app)['sku'], 'MIE-P-IG-001');
      expect(_posted(app, index: 1)['sku'], 'MIE-P-IG-002');
      expect(find.text('Produk disimpan.'), findsOneWidget);
      await dismissInfo(tester);
    });

    testWidgets('a SKU the user typed is never swapped for another when it is refused', (tester) async {
      final app = _setup(mieSkus: ['IDM-01'], posts: [() => FakeReply(409, errorBody('product with sku IDM-9 or the same barcode already exists'))]);
      await _openAdd(tester, app);
      await _type(tester, 0, 'Indomie Goreng');
      await _type(tester, 3, 'Mie Instan');
      await _type(tester, 1, 'IDM-9');
      await _fillRest(tester);
      await _save(tester);

      expect(app.adapter.requests.where((r) => r.method == 'POST' && r.path == ApiPaths.products), hasLength(1));
      expect(_sku(tester), 'IDM-9');
    });
  });

  testWidgets('editing a product keeps its SKU and never reads the others', (tester) async {
    final app = _setup();
    await app.pump(tester, location: '/products', size: const Size(1280, 1100));
    await tester.tap(find.byTooltip('Ubah'));
    await tester.pumpAndSettle();

    expect(_sku(tester), 'MIE-P-IG-001');
    expect(find.text('Otomatis dari kategori, tipe, dan nama'), findsNothing);
    await _type(tester, 0, 'Nama Baru Sama Sekali');
    expect(_sku(tester), 'MIE-P-IG-001');
    expect(app.adapter.requests.where((r) => r.queryParameters['category_id'] != null), isEmpty);
  });

  group('category dropdown', () {
    testWidgets('opens on focus with every category', (tester) async {
      await _openAdd(tester, _setup());
      await tester.tap(formFields.at(3));
      await tester.pumpAndSettle();
      for (final c in ['Mie Instan', 'Minuman', 'Minyak Goreng']) {
        expect(find.text(c).last, findsOneWidget);
      }
    });

    testWidgets('narrows as you type and fills the field when one is chosen', (tester) async {
      await _openAdd(tester, _setup());
      await tester.tap(formFields.at(3));
      await tester.enterText(formFields.at(3), 'min');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Minuman').last);
      await _settleSku(tester);
      expect(_text(tester, 3), 'Minuman');
    });

    testWidgets('offers to create a category that does not exist, and numbers from 001', (tester) async {
      await _openAdd(tester, _setup());
      await _type(tester, 0, 'Nugget Ayam');
      await tester.tap(formFields.at(3));
      await tester.enterText(formFields.at(3), 'Frozen');
      await tester.pumpAndSettle();
      expect(find.text('Buat kategori "Frozen"'), findsOneWidget);

      await tester.tap(find.text('Buat kategori "Frozen"'));
      await _settleSku(tester);
      expect(_text(tester, 3), 'Frozen');
      expect(_sku(tester), 'FRO-P-NA-001');
    });
  });

  group('bulk rows', () {
    // Each row has eight text fields: name, SKU, barcode, category, three prices, stock.
    String rowSku(WidgetTester tester, int row) => _text(tester, row * 8 + 1);

    Future<void> openBulk(WidgetTester tester, CmsHarness app) =>
        app.pump(tester, location: '/products/bulk', size: const Size(1280, 1100));

    Future<void> fillRow(WidgetTester tester, int row, {required String name, required String category}) async {
      await tester.enterText(formFields.at(row * 8), name);
      await tester.enterText(formFields.at(row * 8 + 3), category);
    }

    testWidgets('number one after another, continuing after what the category already has', (tester) async {
      final app = _setup();
      await openBulk(tester, app);
      for (var r = 0; r < 3; r++) {
        await fillRow(tester, r, name: 'Indomie Goreng', category: 'Mie Instan');
      }
      await _settleSku(tester);
      expect([for (var r = 0; r < 3; r++) rowSku(tester, r)], ['MIE-P-IG-002', 'MIE-P-IG-003', 'MIE-P-IG-004']);
    });

    testWidgets('different names get their own counters', (tester) async {
      await openBulk(tester, _setup(mieSkus: ['IDM-01']));
      await fillRow(tester, 0, name: 'Indomie Goreng', category: 'Mie Instan');
      await fillRow(tester, 1, name: 'Sedaap Goreng', category: 'Mie Instan');
      await fillRow(tester, 2, name: 'Indomie Goreng', category: 'Mie Instan');
      await _settleSku(tester);
      expect([for (var r = 0; r < 3; r++) rowSku(tester, r)], ['MIE-P-IG-001', 'MIE-P-SG-001', 'MIE-P-IG-002']);
    });

    testWidgets('a SKU typed in a row is kept, and rows around it never reuse its number', (tester) async {
      await openBulk(tester, _setup(mieSkus: ['IDM-01']));
      await fillRow(tester, 0, name: 'Indomie Goreng', category: 'Mie Instan');
      await fillRow(tester, 1, name: 'Indomie Goreng', category: 'Mie Instan');
      await tester.enterText(formFields.at(2 * 8 + 1), 'MIE-P-IG-005');
      await _settleSku(tester);
      expect(rowSku(tester, 2), 'MIE-P-IG-005');
      expect(rowSku(tester, 0), 'MIE-P-IG-006');
      expect(rowSku(tester, 1), 'MIE-P-IG-007');
    });

    testWidgets('removing a row renumbers the rows below it', (tester) async {
      await openBulk(tester, _setup(mieSkus: ['IDM-01']));
      for (var r = 0; r < 3; r++) {
        await fillRow(tester, r, name: 'Indomie Goreng', category: 'Mie Instan');
      }
      await _settleSku(tester);
      expect(rowSku(tester, 2), 'MIE-P-IG-003');

      await tester.tap(find.byTooltip('Hapus baris').first);
      await _settleSku(tester);
      expect([for (var r = 0; r < 2; r++) rowSku(tester, r)], ['MIE-P-IG-001', 'MIE-P-IG-002']);
    });

    testWidgets('a digital row gets a D without disturbing the others', (tester) async {
      await openBulk(tester, _setup(mieSkus: ['IDM-01']));
      for (var r = 0; r < 2; r++) {
        await fillRow(tester, r, name: 'Indomie Goreng', category: 'Mie Instan');
      }
      await _settleSku(tester);

      await tester.tap(find.text('Fisik').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Digital').last);
      await _settleSku(tester);
      expect(rowSku(tester, 0), 'MIE-D-IG-001');
      expect(rowSku(tester, 1), 'MIE-P-IG-001');
    });

    testWidgets('the category field is a dropdown of the store categories', (tester) async {
      await openBulk(tester, _setup());
      await tester.tap(formFields.at(3));
      await tester.pumpAndSettle();
      for (final c in ['Mie Instan', 'Minuman', 'Minyak Goreng']) {
        expect(find.text(c).last, findsOneWidget);
      }
    });

    testWidgets('what is sent carries the generated SKU and the chosen type', (tester) async {
      final app = _setup(mieSkus: ['IDM-01']);
      await openBulk(tester, app);
      await fillRow(tester, 0, name: 'Indomie Goreng', category: 'Mie Instan');
      for (final (i, v) in [(4, '1000'), (5, '1500'), (6, '1600')]) {
        await tester.enterText(formFields.at(i), v);
      }
      await _settleSku(tester);

      await tester.tap(find.widgetWithText(ShadButton, 'Simpan semua'));
      await tester.pumpAndSettle();
      final body = app.adapter.streamedBodies.map(String.fromCharCodes).singleWhere((b) => b.contains('products.csv'));
      expect(body, contains('MIE-P-IG-001,'));
      expect(body, contains(',physical'));
    });
  });
}
