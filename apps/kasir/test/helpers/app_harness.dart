import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app/app.dart';
import 'package:kasir/app/di.dart';

import 'fixtures.dart';

Map<String, dynamic> loginData() =>
    envelope({'id': 'u1', 'username': 'kasir1', 'role': 'staff', 'token': 'a1', 'refresh_token': 'r1'});

Map<String, dynamic> productJson(Product p) => {
      'id': p.id,
      'sku': p.sku,
      'barcode': p.barcode,
      'product_name': p.name,
      'unit': p.unit.index,
      'product_type': p.type.index,
      'purchase_price': p.purchasePrice,
      'selling_price': p.sellingPrice,
      'selling_price_debt': p.sellingPriceDebt,
      'stock': p.stock,
      'category': '',
    };

/// Full kasir app on fakes: scripted HTTP, in-memory drift, memory stores,
/// controllable connectivity. Nothing touches a real device service.
class AppHarness {
  AppHarness({bool online = false}) : network = FakeNetwork(online);

  final adapter = FakeAdapter();
  final tokens = MemoryTokenStore();
  final store = MemoryStore();
  final FakeNetwork network;
  late final AppDatabase db = AppDatabase(NativeDatabase.memory());

  /// Serves login, refresh, the catalog, and sync with sensible defaults.
  void serveBackend({List<Product> products = const [indomie, aqua]}) {
    adapter
      ..on('POST', ApiPaths.login, (_) => FakeReply(200, loginData()))
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData()))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'has_next': false, 'product_list': products.map(productJson).toList()})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])))
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'has_next': false, 'customer_lists': []})))
      ..on('POST', ApiPaths.transactionsSync, (o) => FakeReply(200, envelope({
            'results': [
              for (final t in (o.data['transactions'] as List).cast<Map>())
                {'client_ref': t['client_ref'], 'status': 'created', 'transaction_id': 't-${t['client_ref']}', 'no_invoice': 'INV-77'},
            ],
          })));
  }

  Future<void> pump(WidgetTester tester, {Size size = const Size(400, 860), double textScale = 1}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await getIt.reset();
    final api = ApiClient(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    setupDependencies(
      config: const AppConfig(baseUrl: 'http://api.test', flavor: 'dev'),
      store: store,
      database: db,
      tokens: tokens,
      network: network,
      api: api,
      bare: api,
      scheduleSync: () async {},
    );
    await tester.pumpWidget(const KasirApp());
    await settle(tester);
  }

  /// Drift streams and timers need real async turns between frames.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> signIn(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), 'kasir1');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await settle(tester);
  }

  Future<void> close() => db.close();
}
