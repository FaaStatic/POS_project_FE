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

/// Summary panel, then chart beside "needs action", then recent transactions
/// beside the details. On phones "needs action" comes first.
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
          AppButton(label: l10n.quickAddProduct, icon: Iconsax.box_add_copy, variant: AppButtonVariant.outline, onPressed: () => context.go('/products?add=1')),
          AppButton(label: l10n.quickAddStaff, icon: Iconsax.user_add_copy, variant: AppButtonVariant.outline, onPressed: () => context.go('/staff?add=1')),
          AppButton(label: l10n.quickAddCustomer, icon: Iconsax.profile_add_copy, variant: AppButtonVariant.outline, onPressed: () => context.go('/customers?add=1')),
          AppButton(label: l10n.quickMonthReport, icon: Iconsax.document_download_copy, variant: AppButtonVariant.outline, onPressed: () => onDownloadMonthReport(context)),
        ],
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final cubit = context.read<DashboardCubit>();
            final summary = state.summary;
            return RefreshIndicator(
              onRefresh: cubit.load,
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 1100;
                  Widget pair(Widget main, Widget side) => wide
                      // Top-aligned: the chart's LayoutBuilder cannot report intrinsic heights.
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: main),
                            const SizedBox(width: Space.lg),
                            Expanded(child: side),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            main,
                            const SizedBox(height: Space.lg),
                            side,
                          ],
                        );

                  final needs = _NeedsAction(state: state);
                  final children = <Widget>[
                    if (!wide) ...[needs, const SizedBox(height: Space.lg)],
                    _SummaryPanel(state: state),
                    const SizedBox(height: Space.lg),
                    if (summary == null && state.loading)
                      const Padding(padding: EdgeInsets.all(Space.xxl), child: LoadingView())
                    else if (summary == null)
                      ErrorState(message: l10n.loadFailed(failureText(context, state.failure!)), onRetry: cubit.load)
                    else ...[
                      pair(
                        SurfaceCard(
                          child: DailyChart(days: summary.daily, title: l10n.dailyChartTitle(_rangeName(l10n, state))),
                        ),
                        wide ? needs : _Details(summary: summary, part: 0),
                      ),
                      const SizedBox(height: Space.lg),
                      pair(_RecentTransactions(items: state.recent), _Details(summary: summary, part: wide ? -1 : 1)),
                    ],
                  ];
                  return ListView(padding: const EdgeInsets.all(Space.lg), children: children);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  static String _rangeName(AppLocalizations l10n, DashboardState s) => switch (s.range) {
    DashboardRange.today => l10n.rangeTodayShort,
    DashboardRange.last7 => l10n.range7,
    DashboardRange.last30 => l10n.range30,
    DashboardRange.thisMonth => l10n.rangeMonth.toLowerCase(),
    DashboardRange.custom => l10n.periodBefore,
  };
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = state.summary;
    final p = state.previous;
    final vs = l10n.vsPrevious(DashboardPage._rangeName(l10n, state));
    final tiles = [
      _StatTile(
        icon: Iconsax.money_recive_copy,
        label: l10n.revenue,
        value: s == null ? '–' : money(context, s.revenue),
        change: s == null || p == null ? null : percentChange(s.revenue, p.revenue),
        vs: vs,
      ),
      _StatTile(
        icon: Iconsax.chart_2_copy,
        label: l10n.grossProfit,
        value: s == null ? '–' : money(context, s.grossProfit),
        change: s == null || p == null ? null : percentChange(s.grossProfit, p.grossProfit),
        vs: vs,
      ),
      _StatTile(
        icon: Iconsax.receipt_2_copy,
        label: l10n.transactionCount,
        value: s == null ? '–' : '${s.transactions}',
        change: s == null || p == null ? null : percentChange(s.transactions, p.transactions),
        vs: vs,
      ),
      _StatTile(
        icon: Iconsax.wallet_money_copy,
        label: l10n.activeReceivables,
        value: s == null ? '–' : money(context, s.debtOutstanding),
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Space.md,
            runSpacing: Space.sm,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(l10n.summaryTitle, style: theme.textTheme.titleLarge)),
                  if (state.loading && s != null) ...[
                    const SizedBox(width: Space.md),
                    const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ],
              ),
              _RangeMenu(state: state),
            ],
          ),
          const SizedBox(height: Space.lg),
          LayoutBuilder(
            builder: (context, c) {
              final columns = c.maxWidth >= 900 ? 4 : (c.maxWidth >= 480 ? 2 : 1);
              return Column(
                spacing: Space.md,
                children: [
                  for (var i = 0; i < tiles.length; i += columns)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: Space.md,
                        children: [for (final t in tiles.skip(i).take(columns)) Expanded(child: t)],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, this.change, this.vs});
  final IconData icon;
  final String label;
  final String value;

  /// Percent vs the previous period; null hides the trend line.
  final double? change;
  final String? vs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = StatusColors.of(context);
    final up = (change ?? 0) >= 0;
    final trendColor = up ? status.success : status.danger;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(Radii.medium)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(Radii.control),
            ),
            child: Icon(icon, color: scheme.onPrimary, size: 22),
          ),
          const SizedBox(height: Space.md),
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: Space.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: theme.textTheme.headlineMedium?.tabular),
          ),
          if (change != null) ...[
            const SizedBox(height: Space.sm),
            Wrap(
              spacing: Space.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(up ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 18, color: trendColor),
                Text(
                  '${change!.abs().toStringAsFixed(change!.abs() < 10 ? 1 : 0)}%',
                  style: theme.textTheme.labelMedium?.tabular.copyWith(color: trendColor),
                ),
                Text(vs!, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RangeMenu extends StatelessWidget {
  const _RangeMenu({required this.state});
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
    return MenuAnchor(
      menuChildren: [
        for (final r in DashboardRange.values)
          MenuItemButton(
            trailingIcon: state.range == r ? const Icon(Icons.check_rounded, size: 18) : null,
            onPressed: () async {
              if (r != DashboardRange.custom) return cubit.select(r);
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 366)),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: state.start, end: state.end),
              );
              if (picked != null) await cubit.select(r, start: picked.start, end: picked.end);
            },
            child: Text(labels[r]!),
          ),
      ],
      builder: (context, controller, _) => ShadButton.outline(
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        leading: const Icon(Iconsax.calendar_1_copy, size: 16),
        trailing: const Icon(Iconsax.arrow_down_1_copy, size: 14),
        child: Text(
          state.range == DashboardRange.custom
              ? '${dateText(context, state.start)} – ${dateText(context, state.end)}'
              : labels[state.range]!,
        ),
      ),
    );
  }
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
    Widget row(IconData icon, Color color, Color bg, String text, VoidCallback onTap, {String? amount}) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.small + 4)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(text),
      subtitle: amount == null ? null : Text(amount, style: theme.textTheme.titleSmall?.tabular),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.needsAction, style: theme.textTheme.titleLarge),
          const SizedBox(height: Space.sm),
          if (state.loading && state.summary == null)
            const LinearProgressIndicator()
          else if (state.nothingToDo)
            row(Iconsax.tick_circle_copy, status.success, status.successContainer, l10n.nothingToDo, () {})
          else ...[
            if (conflicts > 0)
              row(
                Iconsax.warning_2_copy,
                status.warning,
                status.warningContainer,
                l10n.openConflicts(conflicts),
                () => context.go('/transactions?conflicts=1'),
              ),
            if (state.failedPayments > 0)
              row(
                Iconsax.card_remove_copy,
                status.danger,
                status.dangerContainer,
                l10n.failedPayments(state.failedPayments),
                () => context.go('/payments?status=failed&today=1'),
              ),
            if (state.oldestDebts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: Space.md),
                child: Text(l10n.oldestDebts, style: theme.textTheme.titleSmall),
              ),
              for (final d in state.oldestDebts)
                row(
                  Iconsax.wallet_money_copy,
                  status.warning,
                  status.warningContainer,
                  '${d.customerName} · ${dateText(context, d.date)}',
                  () => context.go('/customers/${d.customerId}'),
                  amount: money(context, d.remaining),
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.items});
  final List<Transaction> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final num = theme.textTheme.bodyMedium?.tabular;
    final head = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.md, Space.md),
            child: Row(
              children: [
                Expanded(child: Text(l10n.recentTransactions, style: theme.textTheme.titleLarge)),
                AppButton(label: l10n.seeAll, variant: AppButtonVariant.ghost, onPressed: () => context.go('/transactions')),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
              child: Text(l10n.noTransactions),
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                final full = c.maxWidth >= 560;
                Widget cells(List<(Widget, int)> parts) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.md),
                  child: Row(
                    children: [for (final (w, f) in parts) Expanded(flex: f, child: w)],
                  ),
                );
                return Column(
                  children: [
                    ColoredBox(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: cells([
                        (Text(l10n.invoice, style: head), 3),
                        if (full) (Text(l10n.date, style: head), 3),
                        if (full) (Text(l10n.method, style: head), 2),
                        (Text(l10n.total, style: head, textAlign: TextAlign.end), 2),
                        (Text(l10n.status, style: head, textAlign: TextAlign.end), 2),
                      ]),
                    ),
                    for (final t in items) ...[
                      const Divider(height: 1),
                      InkWell(
                        key: ValueKey(t.id),
                        onTap: () => context.go('/transactions/${t.id}'),
                        child: cells([
                          (Text(t.invoice, style: num, overflow: TextOverflow.ellipsis), 3),
                          if (full) (Text(dateTimeText(context, t.createdAt)), 3),
                          if (full) (Text(methodLabel(l10n, t.method)), 2),
                          (Text(money(context, t.total), style: num, textAlign: TextAlign.end), 2),
                          (
                            Align(
                              alignment: Alignment.centerRight,
                              child: t.stockConflict && !t.conflictReviewed
                                  ? StatusBadge(label: l10n.conflict, tone: BadgeTone.warning)
                                  : StatusBadge(label: l10n.statusDone, tone: BadgeTone.success),
                            ),
                            2,
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: Space.sm),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

/// [part] 0 = top products and payment mix, 1 = credit flow and devices, -1 = all.
class _Details extends StatelessWidget {
  const _Details({required this.summary, required this.part});
  final DashboardSummary summary;
  final int part;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final num = theme.textTheme.bodyMedium?.tabular;
    final payTotal = summary.paymentMethods.fold<int>(0, (a, m) => a + m.total);

    Widget section(String title, List<Widget> rows) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: Space.sm),
        if (rows.isEmpty) Text(l10n.noData) else ...rows,
      ],
    );
    Widget line(String left, String right, {String? sub}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs + 2),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: Space.md,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(left, style: theme.textTheme.bodyLarge),
              if (sub != null) Text(sub, style: theme.textTheme.bodySmall),
            ],
          ),
          Text(right, style: num),
        ],
      ),
    );

    final first = [
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
    ];
    final second = [
      section(l10n.debtFlow, [
        line(l10n.newDebt, money(context, summary.debtNew)),
        line(l10n.paidDebt, money(context, summary.debtPaid)),
      ]),
      section(l10n.devicesOnline, [
        for (final d in summary.devicesOnline) line(d.platform == 'ios' ? 'iOS' : 'Android', '${d.count}'),
      ]),
    ];
    final sections = switch (part) {
      0 => first,
      1 => second,
      _ => [...first, ...second],
    };
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, s) in sections.indexed) ...[if (i > 0) const Divider(height: Space.xxl), s],
        ],
      ),
    );
  }
}
