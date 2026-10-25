import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/labels.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/dashboard_cubit.dart';
import '../widgets/daily_chart.dart';

/// Order follows the PRD: needs action, key numbers, chart, details.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onDownloadMonthReport});

  /// Supplied by the app layer (the report download lives in the reports feature).
  final Future<void> Function(BuildContext context) onDownloadMonthReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
      child: CmsPage(
        title: l10n.dashboardTitle,
        actions: [
          OutlinedButton.icon(onPressed: () => context.go('/products?add=1'), icon: const Icon(Iconsax.box_add), label: Text(l10n.quickAddProduct)),
          OutlinedButton.icon(onPressed: () => context.go('/staff?add=1'), icon: const Icon(Iconsax.user_add), label: Text(l10n.quickAddStaff)),
          OutlinedButton.icon(onPressed: () => context.go('/customers?add=1'), icon: const Icon(Iconsax.profile_add), label: Text(l10n.quickAddCustomer)),
          OutlinedButton.icon(onPressed: () => onDownloadMonthReport(context), icon: const Icon(Iconsax.document_download), label: Text(l10n.quickMonthReport)),
        ],
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) => RefreshIndicator(
            onRefresh: context.read<DashboardCubit>().load,
            child: ListView(
              padding: const EdgeInsets.all(Space.xl),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NeedsAction(state: state),
                      const SizedBox(height: Space.xxl),
                      _RangePicker(state: state),
                      const SizedBox(height: Space.xl),
                      if (state.loading && state.summary == null)
                        const Padding(padding: EdgeInsets.all(Space.xxl), child: LoadingView())
                      else if (state.summary == null)
                        ErrorState(message: l10n.loadFailed(failureText(context, state.failure!)), onRetry: context.read<DashboardCubit>().load)
                      else ...[
                        if (state.loading) const LinearProgressIndicator(),
                        _KeyNumbers(summary: state.summary!),
                        const SizedBox(height: Space.xxl),
                        DailyChart(days: state.summary!.daily, title: l10n.dailyChartTitle(_rangeName(l10n, state))),
                        const SizedBox(height: Space.xxl),
                        _Details(summary: state.summary!),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _rangeName(AppLocalizations l10n, DashboardState s) => switch (s.range) {
        DashboardRange.today => l10n.rangeToday.toLowerCase(),
        DashboardRange.last7 => l10n.range7,
        DashboardRange.last30 => l10n.range30,
        DashboardRange.thisMonth => l10n.rangeMonth.toLowerCase(),
        DashboardRange.custom => '${apiDate(s.start)} – ${apiDate(s.end)}',
      };
}

class _NeedsAction extends StatelessWidget {
  const _NeedsAction({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = StatusColors.of(context);
    final conflicts = state.summary?.openStockConflicts ?? 0;
    Widget row(IconData icon, Color color, String text, VoidCallback onTap, {String? amount}) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: color),
          title: Text(text),
          subtitle: amount == null ? null : Text(amount, style: theme.textTheme.titleSmall?.tabular),
          trailing: const Icon(Iconsax.arrow_right_3, size: 18),
          onTap: onTap,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.needsAction, style: theme.textTheme.titleLarge),
        const SizedBox(height: Space.sm),
        if (state.loading && state.summary == null)
          const LinearProgressIndicator()
        else if (state.nothingToDo)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Iconsax.tick_circle, color: status.success),
            title: Text(l10n.nothingToDo),
          )
        else ...[
          if (conflicts > 0)
            row(Iconsax.warning_2, status.warning, l10n.openConflicts(conflicts), () => context.go('/transactions?conflicts=1')),
          if (state.failedPayments > 0)
            row(Iconsax.card_remove, status.danger, l10n.failedPayments(state.failedPayments), () => context.go('/payments?status=failed&today=1')),
          if (state.oldestDebts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: Space.md),
              child: Text(l10n.oldestDebts, style: theme.textTheme.titleSmall),
            ),
            for (final d in state.oldestDebts)
              row(Iconsax.wallet_money, status.warning, '${d.customerName} · ${dateText(context, d.date)}', () => context.go('/customers/${d.customerId}'),
                  amount: money(context, d.remaining)),
          ],
        ],
      ],
    );
  }
}

class _RangePicker extends StatelessWidget {
  const _RangePicker({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<DashboardCubit>();
    final labels = {
      DashboardRange.today: l10n.rangeToday,
      DashboardRange.last7: l10n.range7,
      DashboardRange.last30: l10n.range30,
      DashboardRange.thisMonth: l10n.rangeMonth,
      DashboardRange.custom: l10n.rangeCustom,
    };
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final r in DashboardRange.values)
          ChoiceChip(
            label: Text(labels[r]!),
            selected: state.range == r,
            onSelected: (_) async {
              if (r != DashboardRange.custom) return cubit.select(r);
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 366)),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: state.start, end: state.end),
              );
              if (picked != null) await cubit.select(r, start: picked.start, end: picked.end);
            },
          ),
      ],
    );
  }
}

/// Revenue leads; the rest support it at a smaller size. No equal-card grid,
/// and no up/down comparison because there is no named comparison period.
class _KeyNumbers extends StatelessWidget {
  const _KeyNumbers({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget support(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(value, style: theme.textTheme.titleLarge?.tabular),
          ],
        );
    return Wrap(
      spacing: Space.xxxl,
      runSpacing: Space.lg,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.revenue, style: theme.textTheme.titleSmall),
            Text(money(context, summary.revenue), style: theme.textTheme.displaySmall?.tabular),
          ],
        ),
        support(l10n.grossProfit, money(context, summary.grossProfit)),
        support(l10n.transactionCount, '${summary.transactions}'),
        support(l10n.activeReceivables, money(context, summary.debtOutstanding)),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final num = theme.textTheme.bodyMedium?.tabular;
    final payTotal = summary.paymentMethods.fold<int>(0, (a, m) => a + m.total);

    Widget section(String title, List<Widget> rows) => ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const Divider(height: Space.lg),
              if (rows.isEmpty) Text(l10n.noData) else ...rows,
            ],
          ),
        );
    Widget line(String left, String right, {String? sub}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: Space.md,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(left, style: theme.textTheme.bodyLarge),
                if (sub != null) Text(sub, style: theme.textTheme.bodySmall),
              ]),
              Text(right, style: num),
            ],
          ),
        );

    return Wrap(
      spacing: Space.xxxl,
      runSpacing: Space.xxl,
      children: [
        section(l10n.topProducts, [
          for (final p in summary.topProducts.take(5))
            line(p.name, money(context, p.total), sub: l10n.sold(formatQty(p.qty, locale: locale))),
        ]),
        section(l10n.paymentMix, [
          for (final m in summary.paymentMethods)
            line(
              methodLabel(l10n, PaymentMethod.fromWire(m.method)),
              money(context, m.total),
              sub: '${m.count}× · ${payTotal == 0 ? 0 : (m.total * 100 / payTotal).round()}%',
            ),
        ]),
        section(l10n.debtFlow, [
          line(l10n.newDebt, money(context, summary.debtNew)),
          line(l10n.paidDebt, money(context, summary.debtPaid)),
        ]),
        section(l10n.devicesOnline, [
          for (final d in summary.devicesOnline) line(d.platform == 'ios' ? 'iOS' : 'Android', '${d.count}'),
        ]),
      ],
    );
  }
}
