import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  testWidgets('primary button fires onPressed', (tester) async {
    var taps = 0;
    await pumpUi(tester, Center(child: AppButton(label: 'Bayar', onPressed: () => taps++)));
    await tester.tap(find.text('Bayar'));
    expect(taps, 1);
  });

  testWidgets('loading button ignores taps and shows a spinner', (tester) async {
    var taps = 0;
    await pumpUi(tester, Center(child: AppButton(label: 'Simpan', loading: true, onPressed: () => taps++)));
    await tester.tap(find.text('Simpan'), warnIfMissed: false);
    expect(taps, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('large button is at least 56dp tall, regular at least 48dp', (tester) async {
    await pumpUi(
      tester,
      Column(children: [
        AppButton(key: const Key('l'), label: 'Bayar', large: true, onPressed: () {}),
        AppButton(key: const Key('r'), label: 'Batal', onPressed: () {}),
      ]),
    );
    expect(tester.getSize(find.byKey(const Key('l'))).height, greaterThanOrEqualTo(56));
    expect(tester.getSize(find.byKey(const Key('r'))).height, greaterThanOrEqualTo(48));
  });

  for (final variant in AppButtonVariant.values) {
    testWidgets('$variant renders at 200% text in dark theme without overflow', (tester) async {
      await pumpUi(
        tester,
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(label: 'Terima pembayaran tunai', variant: variant, expand: true, onPressed: () {}),
        ),
        dark: true,
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Terima pembayaran tunai'), findsOneWidget);
    });
  }

  testWidgets('meets tap target and labelled tap target guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpUi(tester, Center(child: AppButton(label: 'Bayar', onPressed: () {})));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
