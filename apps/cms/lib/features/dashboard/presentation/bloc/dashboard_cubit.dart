import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  const DashboardState({
    this.loading = true,
    this.range = DashboardRange.last30,
    required this.start,
    required this.end,
    this.summary,
    this.previous,
    this.recent = const [],
    this.oldestDebts = const [],
    this.failedPayments = 0,
    this.failure,
  });

  final bool loading;
  final DashboardRange range;
  final DateTime start;
  final DateTime end;
  final DashboardSummary? summary;

  /// Same-length period right before [start], for the trend lines.
  final DashboardSummary? previous;
  final List<Transaction> recent;
  final List<Debt> oldestDebts;
  final int failedPayments;
  final Failure? failure;

  bool get nothingToDo => (summary?.openStockConflicts ?? 0) == 0 && oldestDebts.isEmpty && failedPayments == 0;

  DashboardState loadingCopy({DashboardRange? range, DateTime? start, DateTime? end}) => DashboardState(
    range: range ?? this.range,
    start: start ?? this.start,
    end: end ?? this.end,
    summary: summary,
    previous: previous,
    recent: recent,
    oldestDebts: oldestDebts,
    failedPayments: failedPayments,
  );
}

/// Loads the summary for the range plus everything around it: the previous
/// period (trends), recent transactions, and "needs action" (conflicts, oldest
/// unpaid credit, failed QRIS/VA today).
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._summary, this._debts, this._payments, this._transactions, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(() {
        final r = rangeDates(DashboardRange.last30, (clock ?? DateTime.now)());
        return DashboardState(start: r.start, end: r.end);
      }());

  final GetDashboard _summary;
  final GetDebts _debts;
  final GetPayments _payments;
  final GetTransactions _transactions;
  final DateTime Function() _clock;

  Future<void> select(DashboardRange range, {DateTime? start, DateTime? end}) {
    final preset = rangeDates(range, _clock());
    return load(range: range, start: start ?? preset.start, end: end ?? preset.end);
  }

  Future<void> load({DashboardRange? range, DateTime? start, DateTime? end}) async {
    final s = start ?? state.start, e = end ?? state.end, r = range ?? state.range;
    emit(state.loadingCopy(range: r, start: s, end: e));
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final days = e.difference(s).inDays + 1;
    final prevEnd = s.subtract(const Duration(days: 1));
    final prevStart = prevEnd.subtract(Duration(days: days - 1));
    final (summary, previous, recent, debts, failed, expired) = await (
      _summary(start: s, end: e),
      _summary(start: prevStart, end: prevEnd),
      _transactions(const TransactionQuery(limit: 5)),
      _debts(const DebtQuery(unpaidOnly: true, oldestFirst: true, limit: 5)),
      _payments(PaymentQuery(state: PaymentState.failed, dateStart: today, dateEnd: today, limit: 100)),
      _payments(PaymentQuery(state: PaymentState.expired, dateStart: today, dateEnd: today, limit: 100)),
    ).wait;
    T? ok<T>(Result<T> r) => switch (r) {
      Ok(:final value) => value,
      Err() => null,
    };
    emit(
      DashboardState(
        loading: false,
        range: r,
        start: s,
        end: e,
        summary: ok(summary),
        failure: switch (summary) {
          Err(:final failure) => failure,
          Ok() => null,
        },
        previous: ok(previous),
        recent: ok(recent)?.items ?? const [],
        oldestDebts: ok(debts)?.items ?? const [],
        failedPayments: (ok(failed)?.items.length ?? 0) + (ok(expired)?.items.length ?? 0),
      ),
    );
  }
}

/// Percent change from [before] to [now]; null when there is nothing to compare.
double? percentChange(num now, num before) => before == 0 ? null : (now - before) * 100 / before;
