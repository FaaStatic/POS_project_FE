import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  const choices = [
    SymbolChoice('id', 'Bahasa Indonesia', text: 'ID'),
    SymbolChoice('en', 'English', text: 'EN'),
    SymbolChoice('dark', 'Gelap', icon: Icons.dark_mode_outlined, selectedIcon: Icons.dark_mode),
  ];

  testWidgets('shows only symbols, keeps a spoken label, and marks the picked one', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpUi(tester, SymbolToggle<String>(choices: choices, value: 'en', onChanged: (_) {}));

    expect(find.text('Bahasa Indonesia'), findsNothing);
    expect(find.text('ID'), findsOneWidget);
    expect(tester.getSemantics(find.bySemanticsLabel('English')), isSemantics(label: 'English', isButton: true, isSelected: true));
    expect(tester.getSemantics(find.bySemanticsLabel('Bahasa Indonesia')), isSemantics(label: 'Bahasa Indonesia', isButton: true, isSelected: false));
    handle.dispose();
  });

  testWidgets('tapping an option reports its value; every option is a 48dp target', (tester) async {
    String? picked;
    await pumpUi(tester, SymbolToggle<String>(choices: choices, value: 'id', onChanged: (v) => picked = v));

    await tester.tap(find.text('EN'));
    expect(picked, 'en');
    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    expect(picked, 'dark');
    expect(tester.getSize(find.ancestor(of: find.text('ID'), matching: find.byType(SizedBox)).first).shortestSide, greaterThanOrEqualTo(48));
  });

  testWidgets('the picked option swaps to its filled icon', (tester) async {
    await pumpUi(tester, SymbolToggle<String>(choices: choices, value: 'dark', onChanged: (_) {}));
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
  });
}
