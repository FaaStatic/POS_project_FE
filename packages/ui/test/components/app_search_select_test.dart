import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

const _people = ['Bu Sri', 'Pak Budi', 'Ibu Tini'];

void main() {
  late List<String> asked;
  late List<String?> picked;

  Future<List<String>> search(String q) async {
    asked.add(q);
    return _people.where((p) => p.toLowerCase().contains(q.toLowerCase())).toList();
  }

  setUp(() {
    asked = [];
    picked = [];
  });

  Widget field({bool autofocus = false}) =>
      AppSearchSelect<String>(label: 'Pelanggan', autofocus: autofocus, search: search, labelOf: (p) => p, onChanged: picked.add);

  testWidgets('focusing the empty field lists the first results without a pause', (tester) async {
    await pumpUi(tester, field(autofocus: true));
    await tester.pump();
    expect(asked, ['']);
    for (final p in _people) {
      expect(find.text(p), findsOneWidget);
    }
  });

  testWidgets('typing waits for a pause, then asks once for the final text', (tester) async {
    await pumpUi(tester, field(autofocus: true));
    await tester.pump();
    asked.clear();
    await tester.enterText(find.byType(EditableText), 'b');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(EditableText), 'bud');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(asked, ['bud']);
    expect(find.text('Pak Budi'), findsOneWidget);
    expect(find.text('Bu Sri'), findsNothing);
  });

  testWidgets('a pick is reported, and editing the text away from it clears it', (tester) async {
    await pumpUi(tester, field(autofocus: true));
    await tester.pump();
    await tester.tap(find.text('Pak Budi'));
    await tester.pumpAndSettle();
    expect(picked, ['Pak Budi']);

    await tester.enterText(find.byType(EditableText), 'Pak Bud');
    await tester.pump(const Duration(milliseconds: 400));
    expect(picked, ['Pak Budi', null]);
  });

  testWidgets('a press held on a row keeps the list open until release, so the pick lands', (tester) async {
    await pumpUi(tester, field(autofocus: true));
    await tester.pump();
    final press = await tester.startGesture(tester.getCenter(find.text('Pak Budi')), kind: PointerDeviceKind.mouse);
    await tester.pump(const Duration(milliseconds: 100));
    await press.up();
    await tester.pumpAndSettle();
    expect(picked, ['Pak Budi']);
  });

  testWidgets('errorText shows under the field', (tester) async {
    await pumpUi(tester, AppSearchSelect<String>(label: 'Pelanggan', search: search, labelOf: (p) => p, onChanged: picked.add, errorText: 'Wajib diisi'));
    expect(find.text('Wajib diisi'), findsOneWidget);
  });
}
