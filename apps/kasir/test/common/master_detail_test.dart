import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/master_detail.dart';
import 'package:kasir/l10n/app_localizations.dart';
import 'package:ui/ui.dart';

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.touch.light,
      locale: const Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MasterDetail(
          list: Builder(
            builder: (context) => Column(
              children: [
                for (final id in ['a', 'b'])
                  TextButton(onPressed: () => openDetail(context, id, '/x/$id'), child: Text('open $id')),
              ],
            ),
          ),
          detail: (id) => Text('detail $id'),
          icon: Icons.person,
          hint: (l10n) => l10n.pickCustomerHint,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('a tablet shows the list beside a hint until something is picked', (tester) async {
    await _pump(tester, const Size(1280, 800));
    expect(find.text('open a'), findsOneWidget);
    expect(find.text('Pilih pelanggan untuk melihat detailnya.'), findsOneWidget);
    expect(find.textContaining('detail '), findsNothing);
  });

  testWidgets('picking an item opens it in the right pane and a second pick replaces it', (tester) async {
    await _pump(tester, const Size(1280, 800));
    await tester.tap(find.text('open a'));
    await tester.pump();
    expect(find.text('detail a'), findsOneWidget);
    expect(find.text('Pilih pelanggan untuk melihat detailnya.'), findsNothing);

    await tester.tap(find.text('open b'));
    await tester.pump();
    expect(find.text('detail b'), findsOneWidget);
    expect(find.text('detail a'), findsNothing);
  });

  testWidgets('a phone keeps the single list: no hint, no detail pane', (tester) async {
    await _pump(tester, const Size(412, 892));
    expect(find.text('open a'), findsOneWidget);
    expect(find.text('Pilih pelanggan untuk melihat detailnya.'), findsNothing);
  });
}
