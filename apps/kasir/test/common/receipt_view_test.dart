import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/receipt_view.dart';
import 'package:ui/ui.dart';

ReceiptDocument _doc() => ReceiptDocument(const [
      ReceiptLine('Toko Maju', align: ReceiptAlign.center, bold: true, role: ReceiptRole.store),
      ReceiptLine('Jl. Melati 1', align: ReceiptAlign.center, role: ReceiptRole.address),
      ReceiptLine('--------------------------------'),
      ReceiptLine('Kasir    : kasir1', role: ReceiptRole.info),
      ReceiptLine('Indomie Goreng'),
      ReceiptLine('  2 x Rp 3.500           Rp 7.000'),
      ReceiptLine('TOTAL                    Rp 7.000', bold: true),
      ReceiptLine('Terima kasih', align: ReceiptAlign.center, role: ReceiptRole.footer),
    ]);

Future<void> _pump(WidgetTester tester, {double width = 360, double textScale = 1}) {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  return tester.pumpWidget(MaterialApp(
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: ReceiptView(document: _doc()))),
  ));
}

Text _line(WidgetTester tester, String text) => tester.widget<Text>(find.text(text));

void main() {
  testWidgets('header and footer are centered, the store name is bold, details start at the left', (tester) async {
    await _pump(tester);
    expect(_line(tester, 'Toko Maju').textAlign, TextAlign.center);
    expect(_line(tester, 'Toko Maju').style?.fontWeight, FontWeight.w700);
    expect(_line(tester, 'Jl. Melati 1').textAlign, TextAlign.center);
    expect(_line(tester, 'Jl. Melati 1').style?.fontWeight, isNot(FontWeight.w700));
    expect(_line(tester, 'Terima kasih').textAlign, TextAlign.center);
    expect(_line(tester, 'Kasir    : kasir1').textAlign, TextAlign.start);
    expect(_line(tester, 'TOTAL                    Rp 7.000').style?.fontWeight, FontWeight.w700);
  });

  testWidgets('the paper is white with dark ink, so it reads the same in the dark theme', (tester) async {
    await _pump(tester);
    final paper = tester.widget<DecoratedBox>(find.descendant(of: find.byType(ReceiptView), matching: find.byType(DecoratedBox)).first);
    expect((paper.decoration as BoxDecoration).color, Colors.white);
  });

  testWidgets('every row keeps one cell grid: all lines share the same width', (tester) async {
    await _pump(tester);
    final widths = {
      for (final text in ['Kasir    : kasir1', 'Indomie Goreng', 'TOTAL                    Rp 7.000'])
        text: tester.getSize(find.text(text)).width,
    };
    expect(widths.values.toSet().length, 1, reason: '$widths');
  });

  testWidgets('narrow screens and large text shrink the paper instead of overflowing', (tester) async {
    await _pump(tester, width: 280, textScale: 2);
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ReceiptView)).width, lessThanOrEqualTo(280));
  });

  testWidgets('the app logo sits behind the text as a faint watermark', (tester) async {
    await _pump(tester);
    final logo = find.descendant(of: find.byType(ReceiptView), matching: find.byType(BrandLogo));
    expect(logo, findsOneWidget);
    final opacity = tester.widget<Opacity>(find.ancestor(of: logo, matching: find.byType(Opacity)).first);
    expect(opacity.opacity, lessThan(0.1));
  });

  testWidgets('store name, address and footer are sized from the type scale and the body is 15sp', (tester) async {
    await _pump(tester);
    expect(_line(tester, 'Toko Maju').style?.fontSize, 28);
    expect(_line(tester, 'Jl. Melati 1').style?.fontSize, 8);
    expect(_line(tester, 'Terima kasih').style?.fontSize, 12);
    expect(_line(tester, 'Kasir    : kasir1').style?.fontSize, 12);
    expect(_line(tester, 'Indomie Goreng').style?.fontSize, 15);
  });

  testWidgets('a screen reader reads the receipt as one block', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester);
    expect(find.bySemanticsLabel(RegExp('Toko Maju')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('fill grows the slip into the width it is given, in proportion; without it the phone size stays', (tester) async {
    Future<Size> paper({required bool fill}) async {
      tester.view.physicalSize = const Size(1000, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: ReceiptView(document: _doc(), fill: fill))),
        ),
      ));
      return tester.getSize(find.descendant(of: find.byType(ReceiptView), matching: find.byType(DecoratedBox)).first);
    }

    Future<double> ink({required bool fill}) async {
      await paper(fill: fill);
      final line = find.text('TOTAL                    Rp 7.000');
      // Corners are mapped through the FittedBox, so this is the width drawn on screen.
      return tester.getTopRight(line).dx - tester.getTopLeft(line).dx;
    }

    // The paper takes the width it is given either way; fill scales the writing on it, as a whole.
    final natural = await ink(fill: false);
    final grown = await ink(fill: true);
    expect((await paper(fill: true)).width, 800);
    expect(grown, greaterThan(natural * 1.2));
    expect(grown, lessThanOrEqualTo(800));
  });
}
