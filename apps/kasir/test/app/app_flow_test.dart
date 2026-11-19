import 'package:core/core.dart' show ApiPaths, Customer, Debt, Product;
import 'package:core/mobile.dart';
import 'package:core/testing.dart' show FakeReply, envelope;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';

/// Product "+" buttons, named "Tambah {produk}" for screen readers.
final addButtons = find.byWidgetPredicate((w) => w is Semantics && (w.properties.button ?? false) && (w.properties.label ?? '').startsWith('Tambah '));

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
    await tester.tap(find.text('Lihat keranjang'));
    await app.settle(tester);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);
    await tester.tap(find.textContaining('Bayar Rp'));
    await app.settle(tester);
    await dismissInfo(tester);
    expect(find.textContaining('OFF-'), findsWidgets);
    await tester.tap(find.widgetWithText(ShadButton, 'Selesai'));
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
    await dismissInfo(tester);
    await tester.tap(find.widgetWithText(ShadButton, 'Selesai'));
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
    await tester.tap(find.text('Lihat keranjang'));
    await app.settle(tester);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);

    await tester.scrollUntilVisible(find.widgetWithText(AppTextField, 'Uang diterima'), 200, scrollable: find.byType(Scrollable).last);
    final received = find.descendant(of: find.widgetWithText(AppTextField, 'Uang diterima'), matching: find.byType(EditableText));
    AppButton pay() => tester.widget<AppButton>(find.ancestor(of: find.textContaining('Bayar Rp'), matching: find.byType(AppButton)));
    await tester.enterText(received, '1000');
    await app.settle(tester);
    expect(find.textContaining('Kurang'), findsOneWidget);
    expect(pay().onPressed, isNull);

    await tester.enterText(received, '10000');
    await app.settle(tester);
    expect(find.text('Kembalian'), findsOneWidget);
    // Cash received above the total: the change has to be split before the sale can finish.
    expect(find.textContaining('Belum dibagi'), findsOneWidget);
    expect(pay().onPressed, isNull);

    await tester.ensureVisible(find.text('Sisa sebagai tunai'));
    await tester.pump();
    await tester.tap(find.text('Sisa sebagai tunai'));
    await app.settle(tester);
    expect(find.text('Kembalian sudah pas'), findsOneWidget);
    expect(pay().onPressed, isNotNull);

    await tester.tap(find.text('Uang pas'));
    await app.settle(tester);
    expect(tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Uang pas')).selected, isTrue);
    await tester.runAsync(app.close);
  });

  testWidgets('bottom bar has four tabs; products open from Lainnya with the bar still shown', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(412, 892));
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    await tester.tap(find.text('Lainnya'));
    await app.settle(tester);
    await tester.tap(find.text('Produk'));
    await app.settle(tester);
    expect(find.text('Indomie Goreng'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.runAsync(app.close);
  });

  testWidgets('settings has a manual sync row, disabled while offline', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester);
    await tester.tap(find.text('Lainnya'));
    await app.settle(tester);
    final row = find.widgetWithText(ListTile, 'Sinkronkan sekarang');
    expect(find.text('Semua transaksi sudah terkirim'), findsOneWidget);
    expect(find.text('Lingkungan: Dev'), findsOneWidget);
    await tester.tap(row);
    await app.settle(tester);
    expect(find.text('Tidak ada yang perlu dikirim'), findsOneWidget);

    app.network.set(false);
    await app.settle(tester);
    expect(tester.widget<ListTile>(row).enabled, isFalse);
    await tester.runAsync(app.close);
  });

  testWidgets('opening the keyboard on the search field keeps it focused', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    // Tall enough for the roomy layout; the keyboard then shrinks it to the compact one.
    await app.pump(tester, size: const Size(400, 860));
    addTearDown(tester.view.resetViewInsets);

    final field = find.descendant(of: find.byType(SearchField), matching: find.byType(EditableText)).first;
    await tester.tap(field);
    await app.settle(tester);
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    final strip = find.byType(TransactionTabStrip);
    final inList = find.descendant(of: find.byType(CustomScrollView), matching: strip);
    expect(strip, findsOneWidget);
    expect(inList, findsNothing, reason: 'the tabs, search and categories never scroll with the products');

    tester.view.viewInsets = const FakeViewPadding(bottom: 420);
    await app.settle(tester);
    expect(strip, findsOneWidget, reason: 'the compact layout moves the tabs into the product pane, above the search');
    expect(inList, findsNothing);
    expect(tester.getTopLeft(strip).dy, lessThan(tester.getTopLeft(find.byType(SearchField)).dy));
    expect(find.byType(SearchField), findsOneWidget);
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue, reason: 'the field must stay focused');
    expect(tester.testTextInput.isVisible, isTrue, reason: 'the keyboard must stay open');
    await tester.runAsync(app.close);
  });

  testWidgets('checkout survives 200% text on a narrow phone', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(360, 780), textScale: 2);
    expect(tester.takeException(), isNull);
    // The cart bar appears once the tab has an item.
    await tester.tap(addButtons.first);
    await app.settle(tester);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Lihat keranjang'));
    await app.settle(tester);
    expect(tester.takeException(), isNull);
    await tester.runAsync(app.close);
  });

  testWidgets('debt tab: pick a customer, pay part offline, the receipt shows what is still owed, history lists it apart', (tester) async {
    final app = AppHarness()..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(1100, 800));
    await tester.runAsync(() => DriftCatalogCache(app.db).replaceProducts(const [indomie, aqua]));
    await tester.runAsync(
      () => DriftCatalogCache(app.db).replaceDebts(const [
        Debt(id: 'd1', customerId: 'k1', customerName: 'Bu Sri', total: 9000, remaining: 5000, paid: false),
        Debt(id: 'd2', customerId: 'k2', customerName: 'Pak Budi', total: 2000, remaining: 2000, paid: false),
      ]),
    );
    await app.settle(tester);

    await tester.tap(find.byTooltip('Bayar hutang'));
    await app.settle(tester);
    expect(find.text('Hutang 2'), findsWidgets);
    expect(find.text('Pak Budi'), findsOneWidget);
    expect(find.text('Indomie Goreng'), findsNothing);

    await tester.tap(find.text('Bu Sri'));
    await app.settle(tester);
    expect(find.text('Total hutang'), findsOneWidget);
    final pay = find.widgetWithText(AppButton, 'Bayar hutang');
    await tester.enterText(find.descendant(of: find.widgetWithText(AppTextField, 'Jumlah dibayar'), matching: find.byType(EditableText)), '9000');
    await app.settle(tester);
    expect(tester.widget<AppButton>(pay).onPressed, isNull);

    await tester.enterText(find.descendant(of: find.widgetWithText(AppTextField, 'Jumlah dibayar'), matching: find.byType(EditableText)), '3000');
    await app.settle(tester);
    expect(find.text('Rp 2.000'), findsWidgets);
    await tester.tap(pay);
    await app.settle(tester);
    await dismissInfo(tester);

    expect(find.textContaining('PEMBAYARAN HUTANG'), findsOneWidget);
    expect(find.textContaining('BELUM LUNAS'), findsOneWidget);
    expect(find.text('Batalkan penjualan'), findsNothing);

    GoRouter.of(tester.element(find.byType(Navigator).first)).go('/history');
    await app.settle(tester);
    expect(find.text('Penjualan'), findsOneWidget);
    expect(find.textContaining('HTG-'), findsNothing);
    await tester.tap(find.text('Pembayaran hutang'));
    await app.settle(tester);
    expect(find.textContaining('HTG-'), findsOneWidget);
    expect(find.text('Bu Sri'), findsOneWidget);
    await tester.runAsync(app.close);
  });

  testWidgets('search stays in place while the product list scrolls', (tester) async {
    final app = AppHarness(online: true)..serveBackend(products: [for (var i = 0; i < 40; i++) Product(id: 'p$i', sku: 'S$i', name: 'Barang ${i.toString().padLeft(2, '0')}', sellingPrice: 1000, sellingPriceDebt: 1100, stock: 5)]);
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(400, 860));
    await app.settle(tester);
    final before = tester.getTopLeft(find.byType(SearchField));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getTopLeft(find.byType(SearchField)), before);
    await tester.runAsync(app.close);
  });

  testWidgets('paying on credit: the button adds to the debt and the total is the credit price', (tester) async {
    final app = AppHarness()..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(1100, 800));
    await tester.runAsync(() => DriftCatalogCache(app.db).replaceProducts(const [indomie, aqua]));
    await tester.runAsync(() => DriftCatalogCache(app.db).replaceCustomers(const [Customer(id: 'k1', name: 'Bu Sri')]));
    await app.settle(tester);

    await tester.tap(addButtons.at(1)); // Indomie: 3.500 cash, 4.000 on credit
    await app.settle(tester);
    await tester.tap(find.text('Pilih pelanggan (opsional)'));
    await app.settle(tester);
    await tester.tap(find.text('Bu Sri'));
    await app.settle(tester);
    await tester.tap(find.text('Lanjut ke pembayaran'));
    await app.settle(tester);
    expect(find.textContaining('Bayar Rp 3.500'), findsOneWidget);

    await tester.tap(find.text('Hutang'));
    await app.settle(tester);
    expect(find.text('Tambah hutang Rp 4.000'), findsOneWidget);
    expect(find.textContaining('Bayar Rp'), findsNothing);
    expect(find.text('Total hutang'), findsOneWidget);
    expect(find.text('Rp 4.000'), findsWidgets);
    await tester.runAsync(app.close);
  });

  testWidgets('an empty new tab is closed from the tab itself on a phone, where the cart bar is hidden', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester, size: const Size(390, 844));
    // The only empty tab has nothing to close: it would be replaced by an identical one.
    expect(find.byTooltip('Tutup tab'), findsNothing);

    await tester.tap(find.byTooltip('Pembeli baru'));
    await app.settle(tester);
    expect(find.text('Transaksi 2'), findsWidgets);
    // The test font is wider than Inter, so the cross can sit past the strip's edge; press it directly.
    tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.close_rounded)).onPressed!();
    await app.settle(tester);

    expect(find.text('Transaksi 2'), findsNothing);
    expect(find.text('Transaksi 1'), findsWidgets);
    await tester.runAsync(app.close);
  });

  testWidgets('tablet: a customer opens in the right pane, and the phone still pushes a page', (tester) async {
    Map<String, dynamic> customer() => {'id': 'k1', 'nama': 'Bu Rahma', 'no_hp': '0812', 'alamat': 'Jl. Mawar', 'active': true};
    AppHarness build() => AppHarness(online: true)
      ..serveBackend()
      ..adapter.on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'has_next': false, 'customer_lists': [customer()]})))
      ..adapter.on('GET', ApiPaths.customer('k1'), (_) => FakeReply(200, envelope(customer())));

    final tablet = build();
    await tablet.tokens.writeRefreshToken('r0');
    await tablet.pump(tester, size: const Size(1280, 800));
    await tester.tap(find.text('Pelanggan').first);
    await tablet.settle(tester);
    await tester.tap(find.text('Bu Rahma'));
    await tablet.settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Jl. Mawar'), findsOneWidget, reason: 'the detail sits beside the list');
    expect(find.text('Bu Rahma'), findsWidgets);
    await tester.runAsync(tablet.close);

    final phone = build();
    await phone.tokens.writeRefreshToken('r0');
    await phone.pump(tester, size: const Size(412, 892));
    await tester.tap(find.text('Pelanggan').first);
    await phone.settle(tester);
    await tester.tap(find.text('Bu Rahma'));
    await phone.settle(tester);
    expect(find.text('Jl. Mawar'), findsOneWidget, reason: 'the phone opens the detail as its own page');
    expect(find.text('Tambah pelanggan'), findsNothing);
    await tester.runAsync(phone.close);
  });
}
