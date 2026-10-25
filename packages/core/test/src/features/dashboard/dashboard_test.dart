import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the summary and sends the range', () async {
    final adapter = FakeAdapter()
      ..on('GET', ApiPaths.dashboard, (_) => FakeReply(200, envelope({
            'date_start': '2026-10-01',
            'date_end': '2026-10-25',
            'total_transactions': 120,
            'revenue': 2500000,
            'gross_profit': 400000,
            'debt': {'outstanding': 150000, 'new': 50000, 'paid': 20000},
            'devices_online': [
              {'platform': 'android', 'count': 2},
            ],
            'open_stock_conflicts': 3,
            'daily': [
              {'date': '2026-10-01', 'transactions': 5, 'revenue': 100000, 'gross_profit': 15000},
            ],
            'top_products': [
              {'product_name': 'Indomie', 'qty': 40, 'total': 140000},
            ],
            'payment_methods': [
              {'method': 'tunai', 'count': 100, 'total': 2000000},
            ],
          })));
    final get = GetDashboard(DashboardRepositoryImpl(ApiClient(fakeDio(adapter))));
    final s = (await get(start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 25)) as Ok<DashboardSummary>).value;
    expect([s.transactions, s.revenue, s.grossProfit, s.debtOutstanding, s.openStockConflicts], [120, 2500000, 400000, 150000, 3]);
    expect(s.daily.single.grossProfit, 15000);
    expect(s.topProducts.single.name, 'Indomie');
    expect(s.paymentMethods.single.method, 'tunai');
    expect(s.devicesOnline.single.count, 2);
    expect(adapter.requests.single.queryParameters, {'date_start': '2026-10-01', 'date_end': '2026-10-25'});
  });

  test('rejects inverted or too long ranges', () async {
    final get = GetDashboard(DashboardRepositoryImpl(ApiClient(fakeDio(FakeAdapter()))));
    expect(await get(start: DateTime(2026, 2), end: DateTime(2026, 1)), const Err<DashboardSummary>(ValidationFailure('invalid_range')));
    expect(await get(start: DateTime(2024), end: DateTime(2026)), const Err<DashboardSummary>(ValidationFailure('range_too_long')));
  });

  test('preset ranges are inclusive', () {
    final now = DateTime(2026, 10, 25, 15);
    expect(rangeDates(DashboardRange.today, now), (start: DateTime(2026, 10, 25), end: DateTime(2026, 10, 25)));
    expect(rangeDates(DashboardRange.last7, now).start, DateTime(2026, 10, 19));
    expect(rangeDates(DashboardRange.last30, now).start, DateTime(2026, 9, 26));
    expect(rangeDates(DashboardRange.thisMonth, now).start, DateTime(2026, 10));
  });
}
