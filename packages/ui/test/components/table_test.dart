import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  final columns = [
    TableColumnSpec<String>(label: 'Nama', cell: (_, r) => Text(r)),
    TableColumnSpec<String>(label: 'Dibuat', cell: (_, r) => Text('2026-$r'), secondary: true),
  ];

  Widget table({bool more = false, VoidCallback? onMore, void Function(String)? onTap}) => ResponsiveTable<String>(
        rows: const ['a', 'b'],
        columns: columns,
        rowKey: (r) => r,
        onTap: onTap,
        actions: (_, r) => TextButton(onPressed: () {}, child: Text('Edit $r')),
        hasMore: more,
        onLoadMore: onMore,
      );

  testWidgets('expanded shows every column with headers', (tester) async {
    await pumpUi(tester, table(), size: const Size(1200, 800));
    expect(find.text('Dibuat'), findsOneWidget);
    expect(find.text('2026-a'), findsOneWidget);
  });

  testWidgets('medium hides secondary columns', (tester) async {
    await pumpUi(tester, table(), size: const Size(800, 800));
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Dibuat'), findsNothing);
  });

  testWidgets('compact renders cards with labels, actions, tap, and load more', (tester) async {
    String? tapped;
    var more = 0;
    await pumpUi(tester, table(more: true, onMore: () => more++, onTap: (r) => tapped = r), size: const Size(400, 800));
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.text('Edit a'), findsOneWidget);
    await tester.tap(find.text('a'));
    await tester.tap(find.text('Muat lebih banyak'));
    expect([tapped, more], ['a', 1]);
  });

  testWidgets('cards survive 200% text in dark theme', (tester) async {
    await pumpUi(tester, table(more: true), size: const Size(360, 800), dark: true, textScale: 2);
    expect(tester.takeException(), isNull);
  });

  for (final (name, size, type) in [('page when compact', const Size(400, 800), Scaffold), ('dialog when wide', const Size(1200, 800), Dialog)]) {
    testWidgets('form surface is a $name', (tester) async {
      await pumpUi(tester, Builder(
        builder: (context) => TextButton(
          onPressed: () => showFormSurface<void>(context, title: 'Tambah staff', child: const Text('form')),
          child: const Text('open'),
        ),
      ), size: size);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Tambah staff'), findsOneWidget);
      expect(find.ancestor(of: find.text('form'), matching: find.byType(type)), findsWidgets);
    });
  }
}

