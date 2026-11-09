import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  List<TransactionTab> tabs(int n) => [
        for (var i = 1; i <= n; i++) TransactionTab(id: i, number: i, subtitle: '$i barang · Rp 27.500', highlight: i == 2),
      ];

  testWidgets('tab strip selects tabs and exposes both actions', (tester) async {
    int? selected;
    var added = 0, shown = 0;
    await pumpUi(
      tester,
      TransactionTabStrip(
        tabs: tabs(3),
        activeId: 1,
        onSelect: (id) => selected = id,
        onNew: () => added++,
        onShowAll: () => shown++,
      ),
    );
    await tester.ensureVisible(find.text('Transaksi 2'));
    await tester.tap(find.text('Transaksi 2'));
    // Phone width: icon actions, named by their tooltips.
    await tester.tap(find.byTooltip('Pembeli baru'));
    await tester.tap(find.byTooltip('Semua (3)'));
    expect([selected, added, shown], [2, 1, 1]);
  });

  testWidgets('only the open tab carries a close button, and only when it can be closed', (tester) async {
    int? closed;
    final all = [for (final t in tabs(3)) TransactionTab(id: t.id, number: t.number, subtitle: t.subtitle, closable: t.id != 3)];
    await pumpUi(
      tester,
      TransactionTabStrip(
        tabs: all,
        activeId: 2,
        onSelect: (_) {},
        onNew: () {},
        onShowAll: () {},
        onClose: (id) => closed = id,
        closeLabel: 'Tutup tab',
      ),
    );
    expect(find.byTooltip('Tutup tab'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Tutup tab'));
    await tester.tap(find.byTooltip('Tutup tab'));
    expect(closed, 2);
    expect(tester.getSize(find.byTooltip('Tutup tab')).height, greaterThanOrEqualTo(48));

    await pumpUi(
      tester,
      TransactionTabStrip(tabs: all, activeId: 3, onSelect: (_) {}, onNew: () {}, onShowAll: () {}, onClose: (_) {}, closeLabel: 'Tutup tab'),
    );
    expect(find.byTooltip('Tutup tab'), findsNothing, reason: 'a tab that cannot be closed has no button');
  });

  for (final width in [360.0, 900.0]) {
    testWidgets('tab strip fits ${width}px at 200% text in dark theme', (tester) async {
      await pumpUi(
        tester,
        Align(
          alignment: Alignment.topCenter,
          child: TransactionTabStrip(tabs: tabs(8), activeId: 8, onSelect: (_) {}, onNew: () {}, onShowAll: () {}),
        ),
        dark: true,
        textScale: 2,
        size: Size(width, 800),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Transaksi 8'), findsOneWidget);
    });
  }

  testWidgets('qty stepper steps, clamps at zero, and accepts typed fractions', (tester) async {
    var value = 1.0;
    await pumpUi(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Center(
          child: QtyStepper(value: value, itemName: 'Gula', allowFraction: true, onChanged: (v) => setState(() => value = v)),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Tambah'));
    await tester.pump();
    expect(value, 2);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Kurangi'));
      await tester.pump();
    }
    expect(value, 0);
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '1,5');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(value, 1.5);
  });

  testWidgets('fractional stepper adds and subtracts one from the typed value and caps at three decimals', (tester) async {
    var value = 0.25;
    await pumpUi(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Center(
          child: QtyStepper(value: value, itemName: 'Gula', allowFraction: true, onChanged: (v) => setState(() => value = v)),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Tambah'));
    await tester.pump();
    expect(value, 1.25);
    expect(find.text('1,25'), findsOneWidget);

    await tester.tap(find.text('1,25'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '0,12345');
    expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, '0,123');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(value, 0.123);

    await tester.tap(find.byTooltip('Kurangi'));
    await tester.pump();
    expect(value, 0);
  });

  test('qtyText hides float noise and trailing zeros', () {
    expect(qtyText(1.2500000000000002), '1,25');
    expect(qtyText(3), '3');
    expect(qtyText(0.5), '0,5');
    expect(qtyText(2.125), '2,125');
  });

  testWidgets('qty stepper meets tap target guidance at 200%', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpUi(tester, Center(child: QtyStepper(value: 3, itemName: 'Aqua', onChanged: (_) {})), textScale: 2, dark: true);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('search field reports changes, submit, and clear', (tester) async {
    final changes = <String>[];
    String? submitted;
    await pumpUi(tester, Padding(
      padding: const EdgeInsets.all(16),
      child: SearchField(onChanged: changes.add, onSubmitted: (v) => submitted = v),
    ));
    await tester.enterText(find.byType(EditableText), '899');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(submitted, '899');
    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(changes.last, '');
  });

  testWidgets('confirm dialog returns the choice', (tester) async {
    bool? result;
    await pumpUi(tester, Builder(
      builder: (context) => TextButton(
        onPressed: () async => result = await showConfirmDialog(context, title: 'Hapus?', confirmLabel: 'Hapus', destructive: true),
        child: const Text('open'),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('reason dialog requires at least three characters', (tester) async {
    String? reason = 'unset';
    await pumpUi(tester, Builder(
      builder: (context) => TextButton(
        onPressed: () async => reason = await showReasonDialog(context, title: 'Batal', label: 'Alasan', confirmLabel: 'OK', tooShort: 'Terlalu pendek'),
        child: const Text('open'),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'ab');
    await tester.tap(find.widgetWithText(AppButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.text('Terlalu pendek'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'salah input');
    await tester.tap(find.widgetWithText(AppButton, 'OK'));
    await tester.pumpAndSettle();
    expect(reason, 'salah input');
  });

  for (final dark in [false, true]) {
    testWidgets('tab pills keep text contrast (dark: $dark)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpUi(
        tester,
        Align(
          alignment: Alignment.topCenter,
          child: TransactionTabStrip(tabs: tabs(3), activeId: 2, onSelect: (_) {}, onNew: () {}, onShowAll: () {}),
        ),
        dark: dark,
        size: const Size(900, 400),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }
}
