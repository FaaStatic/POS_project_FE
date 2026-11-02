import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir/common/product_image_field.dart';
import 'package:ui/ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

Map<String, dynamic> _json(Product p, {String image = ''}) => {...productJson(p), 'image': image};

/// Two products, the first with a stored picture, served by list, detail, and patch.
AppHarness _setup({String image = square64Base64}) {
  final app = AppHarness(online: true)..serveBackend();
  app.adapter
    ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'has_next': false, 'product_list': [_json(indomie, image: image), _json(aqua)]})))
    ..on('GET', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(_json(indomie, image: image))))
    ..on('PATCH', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(_json(indomie))));
  return app;
}

Future<void> _open(WidgetTester tester, AppHarness app, String route, {Size size = const Size(412, 900), double textScale = 1}) async {
  await app.tokens.writeRefreshToken('r0');
  await app.pump(tester, size: size, textScale: textScale);
  GoRouter.of(tester.element(find.byType(Navigator).first)).go(route);
  await app.settle(tester);
}

Future<void> _pick(WidgetTester tester, AppHarness app, String label, String name, List<int> bytes) async {
  pickProductImage = () async => (name: name, bytes: Uint8List.fromList(bytes));
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await app.settle(tester);
}

Future<void> _save(WidgetTester tester, AppHarness app) async {
  final save = find.widgetWithText(ShadButton, 'Simpan');
  await tester.scrollUntilVisible(save, 200, scrollable: find.byType(Scrollable).first);
  await tester.tap(save);
  await app.settle(tester);
}

Map<dynamic, dynamic> _patch(AppHarness app) =>
    app.adapter.requests.firstWhere((r) => r.method == 'PATCH' && r.path == ApiPaths.product('p1')).data as Map;

Finder get _avatarImages => find.descendant(of: find.byType(ListTile), matching: find.byType(Image));

void main() {
  final systemPicker = pickProductImage;
  tearDown(() => pickProductImage = systemPicker);

  group('products list', () {
    testWidgets('a base64 WebP from the server is drawn as the product picture', (tester) async {
      final app = _setup();
      await _open(tester, app, '/settings/products');
      // Indomie has a picture, Aqua does not: one image, and Aqua keeps its initials.
      expect(find.text('Indomie Goreng'), findsOneWidget);
      expect(_avatarImages, findsOneWidget);
      expect(find.text('AQ'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.runAsync(app.close);
    });

    testWidgets('a product with no picture shows initials, not a broken image', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products');
      expect(_avatarImages, findsNothing);
      expect(find.text('IG'), findsOneWidget);
      await tester.runAsync(app.close);
    });

    testWidgets('a stored value that is not an image falls back to initials', (tester) async {
      final app = _setup(image: 'bukan gambar!');
      await _open(tester, app, '/settings/products');
      expect(_avatarImages, findsNothing);
      expect(find.text('IG'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.runAsync(app.close);
    });
  });

  group('edit page', () {
    testWidgets('shows the stored picture with the rules', (tester) async {
      final app = _setup();
      await _open(tester, app, '/settings/products/p1');
      expect(find.text('Gambar produk (opsional)'), findsOneWidget);
      expect(find.text('WebP, rasio 1:1, maks 500 KB'), findsOneWidget);
      expect(find.text('Ganti gambar'), findsOneWidget);
      expect(find.byType(ImageUploadField), findsOneWidget);
      await tester.runAsync(app.close);
    });

    testWidgets('a valid WebP is patched as raw base64, same as the CMS', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products/p1');
      await _pick(tester, app, 'Pilih gambar', 'indomie.webp', square64);
      expect(find.text('indomie.webp'), findsOneWidget);
      await _save(tester, app);

      expect(_patch(app), {'image': square64Base64});
      await tester.runAsync(app.close);
    });

    testWidgets('a PNG is refused as not WebP and is not sent', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products/p1');
      await _pick(tester, app, 'Pilih gambar', 'foto.png', pngBytes);
      expect(find.text('Gambar harus berformat WebP.'), findsOneWidget);
      await _save(tester, app);

      // Saving still patches (the form has no changes to withhold), but the refused file is not in it.
      expect(_patch(app).containsKey('image'), isFalse);
      await tester.runAsync(app.close);
    });

    testWidgets('a WebP that is not 1:1 is refused', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products/p1');
      await _pick(tester, app, 'Pilih gambar', 'lebar.webp', wide100x60);
      expect(find.text('Gambar harus persegi (rasio 1:1).'), findsOneWidget);
      await tester.runAsync(app.close);
    });

    testWidgets('over 500 KB is refused, exactly 500 KB is accepted', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products/p1');
      await _pick(tester, app, 'Pilih gambar', 'besar.webp', squareWebpOfSize(500 * 1024 + 1));
      expect(find.text('Ukuran gambar maksimal 500 KB.'), findsOneWidget);

      await _pick(tester, app, 'Pilih gambar', 'pas.webp', squareWebpOfSize(500 * 1024));
      expect(find.text('Ukuran gambar maksimal 500 KB.'), findsNothing);
      expect(find.text('pas.webp'), findsOneWidget);
      await tester.runAsync(app.close);
    });

    testWidgets('removing the picture clears it on the backend', (tester) async {
      final app = _setup();
      await _open(tester, app, '/settings/products/p1');
      await tester.ensureVisible(find.text('Hapus gambar'));
      await tester.tap(find.text('Hapus gambar'));
      await app.settle(tester);
      await _save(tester, app);

      expect(_patch(app), {'image': ''});
      await tester.runAsync(app.close);
    });

    testWidgets('fits a phone at 200% text with an error showing', (tester) async {
      final app = _setup(image: '');
      await _open(tester, app, '/settings/products/p1', size: const Size(360, 780), textScale: 2);
      await _pick(tester, app, 'Pilih gambar', 'foto.png', pngBytes);
      expect(tester.takeException(), isNull);
      await tester.runAsync(app.close);
    });
  });
}
