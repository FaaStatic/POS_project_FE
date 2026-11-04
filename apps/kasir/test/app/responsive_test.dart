import 'package:core/core.dart';
import 'package:core/mobile.dart' show DriftCatalogCache;
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:kasir/features/checkout/presentation/widgets/cart_panel.dart';
import 'package:ui/ui.dart' show AppButton;

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';

const _long = 'Toko Sembako Berkah Jaya Makmur Sentosa Abadi Cabang Pasar Minggu';
const _wide = Product(
  id: 'p9',
  sku: 'SKU-999999999999999999999999',
  barcode: '88888888888888888888',
  name: _long,
  unit: ProductUnit.kardus,
  sellingPrice: 987654321,
  sellingPriceDebt: 987654321,
  stock: 123456.75,
);

void main() {
  const routes = [
    '/checkout', '/history', '/customers', '/customers/new', '/settings',
    '/settings/printer', '/settings/store', '/settings/products', '/settings/products/p9',
  ];
  const sizes = {'phone': Size(360, 780), 'phone_landscape': Size(780, 360), 'tablet': Size(800, 1280), 'landscape': Size(1280, 800)};

  for (final route in routes) {
    for (final MapEntry(key: name, value: size) in sizes.entries) {
      // Overflow and layout errors fail the pump; text scale 1.5 on phones mimics large system fonts.
      testWidgets('$route lays out on $name', (tester) async {
        final app = AppHarness(online: true)..serveBackend(products: const [indomie, _wide]);
        app.adapter.on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'has_next': false, 'customer_lists': [
              {'id': 'k1', 'nama': _long, 'no_hp': '081234567890123', 'alamat': _long, 'active': true, 'debts': []},
            ]})));
        await app.tokens.writeRefreshToken('r0');
        await app.pump(tester, size: size, textScale: name == 'phone' ? 1.5 : 1);
        GoRouter.of(tester.element(find.byType(Navigator).first)).go(route);
        await app.settle(tester);
        expect(tester.takeException(), isNull);
        await tester.runAsync(app.close);
      });
    }
  }

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('a debt tab with a long customer name lays out on $name', (tester) async {
      final app = AppHarness()..serveBackend();
      await app.tokens.writeRefreshToken('r0');
      await app.pump(tester, size: size, textScale: name == 'phone' ? 1.5 : 1);
      await tester.runAsync(
        () => DriftCatalogCache(app.db).replaceDebts([Debt(id: 'd1', customerId: 'k1', customerName: _long, total: 987654321, remaining: 987654321, paid: false)]),
      );
      await app.settle(tester);
      tester.element(find.byType(Scaffold).first).read<CheckoutBloc>().add(const NewDebtTabRequested(customerId: 'k1', customerName: _long));
      await app.settle(tester);
      // Phones and portrait tablets open the payment from the bar; wide screens already show it.
      if (find.byType(CartPanel).evaluate().isEmpty) {
        await tester.tap(find.widgetWithText(AppButton, 'Bayar hutang').last);
        await app.settle(tester);
      }
      expect(tester.takeException(), isNull);
      expect(find.text('Total hutang'), findsOneWidget);
      await tester.runAsync(app.close);
    });
  }
}
