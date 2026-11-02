import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  Future<void> open(WidgetTester tester, InfoKind kind, {String? action, bool dark = false, double scale = 1}) async {
    await pumpUi(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ShadButton(
              onPressed: () => showInfoDialog(context, 'Pembayaran dicatat. Sisa Rp 0.', kind: kind, actionLabel: action),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      dark: dark,
      textScale: scale,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows title, message and a close button that resolves false', (tester) async {
    await open(tester, InfoKind.success);
    expect(find.text('Berhasil'), findsOneWidget);
    expect(find.text('Pembayaran dicatat. Sisa Rp 0.'), findsOneWidget);
    await tester.tap(find.widgetWithText(ShadButton, 'Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(ShadDialog), findsNothing);
  });

  testWidgets('error and info kinds use their own title; the action button is offered first', (tester) async {
    await open(tester, InfoKind.error, action: 'Pasang');
    expect(find.text('Gagal'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Pasang')).dy, lessThan(tester.getTopLeft(find.text('Tutup')).dy));
  });

  testWidgets('survives 200% text in dark theme', (tester) async {
    await open(tester, InfoKind.info, action: 'Pasang', dark: true, scale: 2);
    expect(tester.takeException(), isNull);
  });
}
