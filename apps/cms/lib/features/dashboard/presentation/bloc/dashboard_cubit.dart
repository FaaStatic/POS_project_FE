import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  const DashboardState({
    this.loading = true,
    this.range = DashboardRange.last30,
    required this.start,
    required this.end,
    this.summary,
    this.oldestDebts = const [],
    this.failedPayments = 0,
    this.failure,
  });

  final bool loading;
  final DashboardRange range;
  final DateTime start;
  final DateTime end;
  final DashboardSummary? summary;
  final List<Debt> oldestDebts;
  final int failedPayments;
  final Failure? failure;

  bool get nothingToDo => (summary?.openStockConflicts ?? 0) == 0 && oldestDebts.isEmpty && failedPayments == 0;
}

/// "Needs action" (conflicts, oldest unpaid credit, failed QRIS/VA today) loads
/// alongside the summary for the selected range.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._summary, this._debts, this._payments, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(() {
        final r = rangeDates(DashboardRange.last30, (clock ?? DateTime.now)());
        return DashboardState(start: r.start, end: r.end);
      }());

  final GetDashboard _summary;
  final GetDebts _debts;
  final GetPayments _payments;
  final DateTime Function() _clock;

  Future<void> select(DashboardRange range, {DateTime? start, DateTime? end}) {
    final preset = rangeDates(range, _clock());
    return load(range: range, start: start ?? preset.start, end: end ?? preset.end);
  }

  Future<void> load({DashboardRange? range, DateTime? start, DateTime? end}) async {
    final s = start ?? state.start, e = end ?? state.end, r = range ?? state.range;
    emit(
      DashboardState(
        loading: true,
        range: r,
        start: s,
        end: e,
        summary: state.summary,
        oldestDebts: state.oldestDebts,
        failedPayments: state.failedPayments,
      ),
    );
    final today = DateTime(_clock().year, _clock().month, _clock().day);
    final (summary, debts, failed, expired) = await (
      _summary(start: s, end: e),
      _debts(const DebtQuery(unpaidOnly: true, oldestFirst: true, limit: 5)),
      _payments(PaymentQuery(state: PaymentState.failed, dateStart: today, dateEnd: today, limit: 100)),
      _payments(PaymentQuery(state: PaymentState.expired, dateStart: today, dateEnd: today, limit: 100)),
    ).wait;
    int count(Result<Paged<PaymentRecord>> r) => switch (r) {
      Ok(:final value) => value.items.length,
      Err() => 0,
    };
    emit(
      DashboardState(
        loading: false,
        range: r,
        start: s,
        end: e,
        summary: switch (summary) {
          Ok(:final value) => value,
          Err() => null,
        },
        failure: switch (summary) {
          Err(:final failure) => failure,
          Ok() => null,
        },
        oldestDebts: switch (debts) {
          Ok(:final value) => value.items,
          Err() => const [],
        },
        failedPayments: count(failed) + count(expired),
      ),
    );
  }
}
