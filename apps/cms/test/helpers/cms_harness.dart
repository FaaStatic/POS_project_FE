import 'package:cms/app/app.dart';
import 'package:cms/app/di.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

Map<String, dynamic> ownerLogin() =>
    envelope({'id': 'u1', 'username': 'owner', 'role': 'superadmin', 'token': 'a1', 'refresh_token': ''});

/// CMS on a scripted backend, already signed in through the refresh cookie.
class CmsHarness {
  final adapter = FakeAdapter();

  Future<void> pump(WidgetTester tester, {String? location, Size size = const Size(1280, 900), double textScale = 1}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    adapter.routes.putIfAbsent('POST ${ApiPaths.refresh}', () => (_) => FakeReply(200, ownerLogin()));
    await getIt.reset();
    final api = ApiClient(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    setupDependencies(
      config: const AppConfig(baseUrl: 'http://api.test', flavor: 'dev'),
      store: MemoryStore(),
      api: api,
      bare: api,
      usesCookie: true,
    );
    await tester.pumpWidget(CmsApp(initialLocation: location));
    await tester.pumpAndSettle();
  }
}

Map<String, dynamic> dashboardJson({int conflicts = 0}) => {
      'date_start': '2026-09-26',
      'date_end': '2026-10-25',
      'total_transactions': 120,
      'revenue': 2500000,
      'gross_profit': 400000,
      'debt': {'outstanding': 150000, 'new': 50000, 'paid': 20000},
      'devices_online': [
        {'platform': 'android', 'count': 2},
      ],
      'open_stock_conflicts': conflicts,
      'daily': [
        {'date': '2026-10-24', 'transactions': 5, 'revenue': 100000, 'gross_profit': 15000},
        {'date': '2026-10-25', 'transactions': 7, 'revenue': 140000, 'gross_profit': 21000},
      ],
      'top_products': [
        {'product_name': 'Indomie Goreng', 'qty': 40, 'total': 140000},
      ],
      'payment_methods': [
        {'method': 'tunai', 'count': 100, 'total': 2000000},
        {'method': 'qris', 'count': 20, 'total': 500000},
      ],
    };

/// Dashboard, needs-action debts, and payments with nothing to follow up by default.
void serveDashboard(FakeAdapter adapter, {int conflicts = 0, bool oldDebt = false, bool failedPayment = false}) => adapter
  ..on('GET', ApiPaths.dashboard, (_) => FakeReply(200, envelope(dashboardJson(conflicts: conflicts))))
  ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({
        'transaction_list': [
          if (oldDebt) {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000, 'date_debt': '2026-08-01'},
        ],
      })))
  ..on('GET', ApiPaths.payments, (o) => FakeReply(200, envelope({
        'payments': [
          if (failedPayment && o.queryParameters['status'] == 'failed') {'id': 'x', 'order_id': 'ORD-9', 'method': 'qris', 'status': 'failed', 'gross_amount': 1000},
        ],
      })));

/// Text inputs other than the page search field.
final formFields = find.byElementPredicate(
  (e) => e.widget is EditableText && e.findAncestorWidgetOfExactType<SearchField>() == null,
  description: 'form text fields',
);
