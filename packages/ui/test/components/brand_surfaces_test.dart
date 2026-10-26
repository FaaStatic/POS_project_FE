import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('selected chip and ink surfaces meet contrast (dark: $dark)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpUi(
        tester,
        Builder(builder: (context) {
          final shell = ShellColors.of(context);
          return Column(children: [
            ChoiceChip(label: const Text('Semua'), selected: true, onSelected: (_) {}),
            ChoiceChip(label: const Text('Minuman'), selected: false, onSelected: (_) {}),
            Container(color: shell.background, padding: const EdgeInsets.all(16), child: Text('Transaksi', style: TextStyle(color: shell.foreground))),
          ]);
        }),
        dark: dark,
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }

  testWidgets('initial avatar shows two initials and survives a broken image', (tester) async {
    await pumpUi(tester, const Column(children: [
      InitialAvatar(name: 'Indomie Goreng'),
      InitialAvatar(name: 'aqua'),
      InitialAvatar(name: '  '),
    ]));
    expect(find.text('IG'), findsOneWidget);
    expect(find.text('AQ'), findsOneWidget);
    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('surface card is tappable', (tester) async {
    var taps = 0;
    await pumpUi(tester, SurfaceCard(onTap: () => taps++, child: const Text('Omzet')));
    await tester.tap(find.text('Omzet'));
    expect(taps, 1);
  });
}
