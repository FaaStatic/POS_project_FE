import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

/// Indomie sits in "Mie Instan"; the store also has "Minuman" and "Sembako".
AppHarness _setup() {
  final app = AppHarness(online: true)..serveBackend();
  Map<String, dynamic> json() => {...productJson(indomie), 'category_id': 'c1', 'category': 'Mie Instan'};
  app.adapter
    ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
          {'id': 'c1', 'name': 'Mie Instan', 'product_count': 1},
          {'id': 'c2', 'name': 'Minuman', 'product_count': 0},
          {'id': 'c3', 'name': 'Sembako', 'product_count': 0},
        ])))
    ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'has_next': false, 'product_list': [json()]})))
    ..on('GET', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(json())))
    ..on('PATCH', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(json())));
  return app;
}

Future<void> _open(WidgetTester tester, AppHarness app, {Size size = const Size(412, 900), double textScale = 1}) async {
  await app.tokens.writeRefreshToken('r0');
  await app.pump(tester, size: size, textScale: textScale);
  GoRouter.of(tester.element(find.byType(Navigator).first)).go('/settings/products/p1');
  await app.settle(tester);
}

Finder get _category => find.descendant(of: find.byType(AppAutocomplete), matching: find.byType(EditableText));

Future<void> _save(WidgetTester tester, AppHarness app) async {
  final save = find.widgetWithText(ShadButton, 'Simpan');
  await tester.scrollUntilVisible(save, 200, scrollable: find.byType(Scrollable).first);
  await tester.tap(save);
  await app.settle(tester);
}

Iterable<RequestOptions> _patches(AppHarness app) => app.adapter.requests.where((r) => r.method == 'PATCH');

void main() {
  testWidgets('starts with the product category in a searchable field', (tester) async {
    final app = _setup();
    await _open(tester, app);
    expect(find.byType(AppAutocomplete), findsOneWidget);
    expect(tester.widget<EditableText>(_category).controller.text, 'Mie Instan');
    await tester.runAsync(app.close);
  });

  testWidgets('opens with every existing category, and narrows as you type', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await tester.ensureVisible(_category);
    await tester.tap(_category);
    await tester.enterText(_category, '');
    await app.settle(tester);
    for (final c in ['Minuman', 'Sembako']) {
      expect(find.text(c), findsOneWidget);
    }

    await tester.enterText(_category, 'sem');
    await app.settle(tester);
    expect(find.text('Sembako'), findsOneWidget);
    expect(find.text('Minuman'), findsNothing);
    await tester.runAsync(app.close);
  });

  testWidgets('a chosen category is what is patched', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await tester.ensureVisible(_category);
    await tester.tap(_category);
    await tester.enterText(_category, 'sem');
    await app.settle(tester);
    await tester.tap(find.text('Sembako'));
    await app.settle(tester);
    await _save(tester, app);

    expect(_patches(app).single.data, {'category': 'Sembako'});
    await tester.runAsync(app.close);
  });

  testWidgets('typed in another case, it is saved with the store spelling', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await tester.ensureVisible(_category);
    await tester.enterText(_category, 'minuman');
    await app.settle(tester);
    await _save(tester, app);

    expect(_patches(app).single.data, {'category': 'Minuman'});
    await tester.runAsync(app.close);
  });

  testWidgets('a category that does not exist is refused, since staff cannot create one', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await tester.ensureVisible(_category);
    await tester.enterText(_category, 'Frozen');
    await app.settle(tester);
    expect(find.textContaining('Buat'), findsNothing, reason: 'no create row for staff');
    await _save(tester, app);

    expect(find.text('Pilih kategori yang sudah ada.'), findsOneWidget);
    expect(_patches(app), isEmpty);
    await tester.runAsync(app.close);
  });

  testWidgets('an empty category is refused', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await tester.ensureVisible(_category);
    await tester.enterText(_category, '');
    await app.settle(tester);
    await _save(tester, app);

    expect(_patches(app), isEmpty);
    await tester.runAsync(app.close);
  });

  testWidgets('an older product with no category can still be saved', (tester) async {
    final app = _setup();
    final bare = {...productJson(indomie), 'category': ''};
    app.adapter
      ..on('GET', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(bare)))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'has_next': false, 'product_list': [bare]})));
    await _open(tester, app);
    await _save(tester, app);

    expect(_patches(app), hasLength(1), reason: 'the empty category is the existing value, not an error');
    expect(find.text('Pilih kategori yang sudah ada.'), findsNothing);
    await tester.runAsync(app.close);
  });

  testWidgets('leaving the category alone does not patch it', (tester) async {
    final app = _setup();
    await _open(tester, app);
    await _save(tester, app);
    expect(_patches(app).single.data, isNot(contains('category')));
    await tester.runAsync(app.close);
  });

  testWidgets('fits a phone at 200% text with the list open', (tester) async {
    final app = _setup();
    await _open(tester, app, size: const Size(360, 780), textScale: 2);
    await tester.ensureVisible(_category);
    await tester.tap(_category);
    await tester.enterText(_category, 'm');
    await app.settle(tester);
    expect(tester.takeException(), isNull);
    await tester.runAsync(app.close);
  });
}
