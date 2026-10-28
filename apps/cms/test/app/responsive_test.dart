import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/cms_harness.dart';

const _long = 'Toko Sembako Berkah Jaya Makmur Sentosa Abadi Cabang Pasar Minggu';
const _money = 987654321;

void _serveEverything(FakeAdapter adapter) {
  serveDashboard(adapter, conflicts: 3, oldDebt: true, failedPayment: true);
  final trx = {
    'transaction_id': 't1',
    'invoice_number': 'OFF-kasir-android-0001-000123',
    'payment_type': 3,
    'total_transaction': _money,
    'total_profit': _money,
    'stock_conflict': true,
    'conflict_reviewed': false,
    'created_at': '2026-10-25T08:00:00Z',
    'transaction_details': [
      {'product_id': 'p1', 'product_name': _long, 'price': _money, 'qty': 1234.5, 'subtotal': _money},
    ],
  };
  adapter
    ..on('GET', ApiPaths.transactions, (_) => FakeReply(200, envelope({'list_transaction': [trx]})))
    ..on('GET', ApiPaths.transaction('t1'), (_) => FakeReply(200, envelope(trx)))
    ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': [
          {
            'id': 'p1', 'sku': 'SKU-${'9' * 30}', 'barcode': '8' * 20, 'product_name': _long, 'unit': 4, 'product_type': 0,
            'purchase_price': _money, 'selling_price': _money, 'selling_price_debt': _money, 'stock': 123456.75, 'category': _long,
          },
        ]})))
    ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([
          {'id': 'c1', 'name': _long, 'product_count': 12345},
        ])))
    ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'customer_lists': [
          {'id': 'k1', 'nama': _long, 'no_hp': '081234567890123', 'alamat': _long, 'active': true, 'debts': []},
        ]})))
    ..on('GET', ApiPaths.users, (_) => FakeReply(200, envelope({'staff': [
          {'id': 's1', 'username': 'kasir_shift_pagi_cabang_pasar_minggu', 'role': 'staff', 'active': false, 'created_at': '2026-10-01T00:00:00Z'},
        ]})))
    ..on('GET', ApiPaths.devices, (_) => FakeReply(200, envelope([
          {'id': 'd1', 'device_id': 'kasir-1761379200000000', 'platform': 'android', 'username': _long, 'last_used_at': '2026-10-25T08:00:00Z'},
        ])))
    ..on('GET', ApiPaths.payments, (_) => FakeReply(200, envelope({'payments': [
          {'id': 'x', 'order_id': 'ORD-20261025-${'7' * 20}', 'method': 'va_bca', 'status': 'expired', 'gross_amount': _money, 'fee_amount': _money, 'created_at': '2026-10-25T08:00:00Z'},
        ]})));
}

void main() {
  const routes = [
    '/dashboard', '/transactions', '/transactions/t1', '/payments', '/debts', '/reports',
    '/products', '/products/bulk', '/categories', '/customers', '/staff', '/devices', '/settings',
  ];
  const sizes = {'phone': Size(360, 780), 'tablet': Size(800, 1024), 'desktop': Size(1440, 900)};

  for (final route in routes) {
    for (final MapEntry(key: name, value: size) in sizes.entries) {
      // Overflow and layout errors fail the pump; text scale 1.5 on phones mimics large system fonts.
      testWidgets('$route lays out on $name', (tester) async {
        final app = CmsHarness();
        _serveEverything(app.adapter);
        await app.pump(tester, location: route, size: size, textScale: name == 'phone' ? 1.5 : 1);
        expect(tester.takeException(), isNull);
        expect(find.textContaining('Gagal memuat'), findsNothing, reason: 'fixtures must parse so the real layout renders');
      });
    }
  }
}
