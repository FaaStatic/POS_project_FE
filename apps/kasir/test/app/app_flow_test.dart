import 'package:core/mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';

/// Product "+" buttons, named "Tambah {produk}" for screen readers.
final addButtons = find.byWidgetPredicate((w) => w is IconButton && (w.tooltip ?? '').startsWith('Tambah '));

void main() {
  testWidgets('first launch shows login; signing in opens Transaksi 1 and stores the refresh token', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.pump(tester);
    expect(find.text('Masuk Kasir'), findsOneWidget);
    await app.signIn(tester);
    expect(find.text('Transaksi 1'), findsWidgets);
    expect(await app.tokens.readRefreshToken(), 'r1');
    await tester.runAsync(app.close);
  });

  testWidgets('relaunch with a stored refresh token skips login and loads the catalog', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester);
    expect(find.text('Indomie Goreng'), findsOneWidget);
    expect(find.text('Aqua 600ml'), findsOneWidget);
    await tester.runAsync(app.close);
  });

  testWidgets('offline cash sale is queued, shown in the banner, then synced when back online', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester);
    app.network.set(false);
    await app.settle(tester);
    expect(find.text('Tidak ada koneksi internet'), findsOneWidget);

    await tester.tap(addButtons.first);
    await app.settle(tester);
    await tester.tap(find.byTooltip('Lihat keranjang'));
    await app.settle(tester);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);
    await tester.tap(find.textContaining('Bayar Rp'));
    await app.settle(tester);
    expect(find.textContaining('OFF-'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Selesai'));
    await app.settle(tester);
    expect(find.textContaining('1 transaksi belum terkirim'), findsOneWidget);

    app.network.set(true);
    await app.settle(tester);
    expect(find.textContaining('belum terkirim'), findsNothing);
    final sales = await tester.runAsync(() => app.db.select(app.db.sales).get());
    expect(sales!.single.receiptNumber, 'INV-77');
    await tester.runAsync(app.close);
  });

  testWidgets('parallel tabs: pay Transaksi 2, Transaksi 1 keeps its cart', (tester) async {
    final app = AppHarness()..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(1100, 800));
    // Offline start: the cache is empty, so seed it the way a previous sync would have.
    await tester.runAsync(() => DriftCatalogCache(app.db).replaceProducts(const [indomie, aqua]));
    await app.settle(tester);

    // List order is by name: Aqua, then Indomie.
    await tester.tap(addButtons.at(0));
    await app.settle(tester);
    await tester.tap(find.text('Pembeli baru'));
    await app.settle(tester);
    await tester.tap(addButtons.at(1));
    await app.settle(tester);
    expect(find.text('Transaksi 2'), findsWidgets);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);
    await tester.tap(find.textContaining('Bayar Rp'));
    await app.settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Selesai'));
    await app.settle(tester);

    expect(find.text('Transaksi 2'), findsNothing);
    expect(find.text('Transaksi 1'), findsWidgets);
    expect(find.text('Aqua 600ml'), findsNWidgets(2));
    await tester.runAsync(app.close);
  });

  testWidgets('cash payment shows the shortfall and blocks Bayar until enough is received', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester);
    await tester.tap(addButtons.first);
    await app.settle(tester);
    await tester.tap(find.byTooltip('Lihat keranjang'));
    await app.settle(tester);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);

    await tester.scrollUntilVisible(find.widgetWithText(AppTextField, 'Uang diterima'), 200, scrollable: find.byType(Scrollable).last);
    final received = find.descendant(of: find.widgetWithText(AppTextField, 'Uang diterima'), matching: find.byType(TextField));
    AppButton pay() => tester.widget<AppButton>(find.ancestor(of: find.textContaining('Bayar Rp'), matching: find.byType(AppButton)));
    await tester.enterText(received, '1000');
    await app.settle(tester);
    expect(find.textContaining('Kurang'), findsOneWidget);
    expect(pay().onPressed, isNull);

    await tester.enterText(received, '10000');
    await app.settle(tester);
    expect(find.text('Kembalian'), findsOneWidget);
    expect(pay().onPressed, isNotNull);

    await tester.tap(find.text('Uang pas'));
    await app.settle(tester);
    expect(tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Uang pas')).selected, isTrue);
    await tester.runAsync(app.close);
  });

  testWidgets('checkout survives 200% text on a narrow phone', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(360, 780), textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Lihat keranjang'));
    await app.settle(tester);
    expect(tester.takeException(), isNull);
    await tester.runAsync(app.close);
  });
}
