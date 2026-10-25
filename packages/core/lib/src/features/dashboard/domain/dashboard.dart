import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/failure.dart';
import '../../../common/result.dart';

part 'dashboard.freezed.dart';

@freezed
abstract class DashboardDay with _$DashboardDay {
  const factory DashboardDay({required DateTime date, required int transactions, required int revenue, required int grossProfit}) =
      _DashboardDay;
}

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required DateTime start,
    required DateTime end,
    required int transactions,
    required int revenue,
    required int grossProfit,
    required int debtOutstanding,
    required int debtNew,
    required int debtPaid,
    required int openStockConflicts,
    @Default([]) List<DashboardDay> daily,
    @Default([]) List<({String name, double qty, int total})> topProducts,
    @Default([]) List<({String method, int count, int total})> paymentMethods,
    @Default([]) List<({String platform, int count})> devicesOnline,
  }) = _DashboardSummary;
}

abstract interface class DashboardRepository {
  /// Backend default is today; ranges are capped at 366 days.
  Future<Result<DashboardSummary>> summary({required DateTime start, required DateTime end});
}

class GetDashboard {
  const GetDashboard(this._repo);
  final DashboardRepository _repo;

  Future<Result<DashboardSummary>> call({required DateTime start, required DateTime end}) {
    if (end.isBefore(start)) return Future.value(const Err(ValidationFailure('invalid_range')));
    if (end.difference(start).inDays > 366) return Future.value(const Err(ValidationFailure('range_too_long')));
    return _repo.summary(start: start, end: end);
  }
}

enum DashboardRange { today, last7, last30, thisMonth, custom }

/// Inclusive start/end dates for a preset range, relative to [now].
({DateTime start, DateTime end}) rangeDates(DashboardRange range, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return switch (range) {
    DashboardRange.today || DashboardRange.custom => (start: today, end: today),
    DashboardRange.last7 => (start: today.subtract(const Duration(days: 6)), end: today),
    DashboardRange.last30 => (start: today.subtract(const Duration(days: 29)), end: today),
    DashboardRange.thisMonth => (start: DateTime(now.year, now.month), end: today),
  };
}
