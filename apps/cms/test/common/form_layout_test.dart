import 'package:cms/common/form_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _field(String id) => SizedBox(key: ValueKey(id), height: 40);

Future<List<Offset>> _layout(
  WidgetTester tester, {
  required int fields,
  required double width,
  bool wrap = false,
  double minWidth = 200,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 600);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: FieldRow(wrap: wrap, minWidth: minWidth, children: [for (var i = 0; i < fields; i++) _field('f$i')]),
      ),
    ),
  );
  return [for (var i = 0; i < fields; i++) tester.getTopLeft(find.byKey(ValueKey('f$i')))];
}

/// Distinct rows (by top edge) and how many fields sit on each.
List<int> _rowSizes(List<Offset> tops) {
  final rows = <double, int>{};
  for (final t in tops) {
    rows.update(t.dy, (n) => n + 1, ifAbsent: () => 1);
  }
  return (rows.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) => e.value).toList();
}

void main() {
  testWidgets('everything fits: one row', (tester) async {
    expect(_rowSizes(await _layout(tester, fields: 3, width: 900)), [3]);
  });

  testWidgets('not all fit and no wrap: they stack', (tester) async {
    expect(_rowSizes(await _layout(tester, fields: 3, width: 500)), [1, 1, 1]);
  });

  testWidgets('wrap: four fields on a narrow row go 2 + 2, never 3 + 1', (tester) async {
    // Room for three 200px fields, but a row of three would strand the fourth.
    expect(_rowSizes(await _layout(tester, fields: 4, width: 700, wrap: true)), [2, 2]);
  });

  testWidgets('wrap: five fields go 3 + 2', (tester) async {
    expect(_rowSizes(await _layout(tester, fields: 5, width: 700, wrap: true)), [3, 2]);
  });

  testWidgets('large text always stacks', (tester) async {
    expect(_rowSizes(await _layout(tester, fields: 3, width: 900, textScale: 2)), [1, 1, 1]);
  });
}
