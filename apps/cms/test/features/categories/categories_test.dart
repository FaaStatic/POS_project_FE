import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cms_harness.dart';

void main() {
  testWidgets('categories: delete disabled while used, add rejects duplicates, rename, delete', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
            {'id': 'c1', 'name': 'Sembako', 'product_count': 3},
            {'id': 'c2', 'name': 'Kosong', 'product_count': 0},
          ])))
      ..on('PATCH', ApiPaths.category('c1'), (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.category('c2'), (_) => FakeReply(200, envelope(null)));
    await app.pump(tester, location: '/categories');
    expect(find.text('3 produk'), findsOneWidget);
    final deletes = find.widgetWithText(TextButton, 'Hapus');
    expect(tester.widget<TextButton>(deletes.at(0)).onPressed, isNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Tambah kategori'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), ' sembako ');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama kategori sudah ada.'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Batal'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Ganti nama').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Sembako Pokok');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.last.path, ApiPaths.categories);

    await tester.tap(deletes.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Kategori dihapus.'), findsOneWidget);
  });

  testWidgets('categories empty state on a phone at 200%', (tester) async {
    final app = CmsHarness();
    app.adapter.on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])));
    await app.pump(tester, location: '/categories', size: const Size(360, 780), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Belum ada kategori. Tambah kategori pertama.'), findsOneWidget);
  });
}
