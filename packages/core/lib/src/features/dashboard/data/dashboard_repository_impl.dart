import '../../../common/guard.dart';
import '../../../common/json.dart';
import '../../../common/result.dart';
import '../../../constants/api_paths.dart';
import '../../../format/formatters.dart';
import '../../../network/api_client.dart';
import '../domain/dashboard.dart';

DashboardSummary dashboardFromJson(Map<String, dynamic> j, DateTime start, DateTime end) {
  final debt = readMap(j['debt']);
  return DashboardSummary(
    start: readDate(j['date_start']) ?? start,
    end: readDate(j['date_end']) ?? end,
    transactions: readInt(j['total_transactions']),
    revenue: readInt(j['revenue']),
    grossProfit: readInt(j['gross_profit']),
    debtOutstanding: readInt(debt['outstanding']),
    debtNew: readInt(debt['new']),
    debtPaid: readInt(debt['paid']),
    openStockConflicts: readInt(j['open_stock_conflicts']),
    daily: [
      for (final d in readList(j['daily']))
        if (readDate(d['date']) case final date?)
          DashboardDay(date: date, transactions: readInt(d['transactions']), revenue: readInt(d['revenue']), grossProfit: readInt(d['gross_profit'])),
    ],
    topProducts: [for (final p in readList(j['top_products'])) (name: readString(p['product_name']), qty: readDouble(p['qty']), total: readInt(p['total']))],
    paymentMethods: [for (final m in readList(j['payment_methods'])) (method: readString(m['method']), count: readInt(m['count']), total: readInt(m['total']))],
    devicesOnline: [for (final d in readList(j['devices_online'])) (platform: readString(d['platform']), count: readInt(d['count']))],
  );
}

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<Result<DashboardSummary>> summary({required DateTime start, required DateTime end}) => guard(() async =>
      dashboardFromJson(readMap(await _api.get(ApiPaths.dashboard, query: {'date_start': apiDate(start), 'date_end': apiDate(end)})), start, end));
}
