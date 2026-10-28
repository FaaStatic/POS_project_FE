import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
  const sizes = {'phone': Size(360, 780), 'tablet': Size(800, 1280), 'landscape': Size(1280, 800)};

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
}
