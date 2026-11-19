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

/// Summary panel, then chart beside "needs action", recent transactions beside the top
/// products, and three small breakdown cards. Cards that share a row are the same height.
/// On narrow screens "needs action" comes first and everything stacks.
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
                  // IntrinsicHeight is safe here: the chart plot sits in a fixed-height box, so nothing
                  // below it is asked for intrinsic sizes.
                  Widget row(List<(int, Widget)> cells) => IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Space.lg,
                      children: [for (final (flex, card) in cells) Expanded(flex: flex, child: card)],
                    ),
                  );

                  List<Widget> cards(DashboardSummary summary) {
                    final chart = SurfaceCard(
                      child: DailyChart(days: summary.daily, title: l10n.dailyChartTitle(_rangeName(l10n, state))),
                    );
                    final recent = _RecentTransactions(items: state.recent, full: wide ? true : null);
                    final top = _TopProducts(products: summary.topProducts);
                    final mix = _PaymentMix(summary: summary);
                    final debt = _DebtFlow(summary: summary);
                    final devices = _DevicesOnline(summary: summary);
                    return wide
                        ? [
                            row([(2, chart), (1, _NeedsAction(state: state))]),
                            row([(2, recent), (1, top)]),
                            row([(1, mix), (1, debt), (1, devices)]),
                          ]
                        : [chart, top, recent, mix, debt, devices];
                  }

                  final items = <Widget>[
                    if (!wide) _NeedsAction(state: state),
                    _SummaryPanel(state: state),
                    if (summary == null && state.loading)
                      const Padding(padding: EdgeInsets.all(Space.xxl), child: LoadingView())
                    else if (summary == null)
                      ErrorState(message: l10n.loadFailed(failureText(context, state.failure!)), onRetry: cubit.load)
                    else
                      ...cards(summary),
                  ];
                  return ListView.separated(
                    padding: const EdgeInsets.all(Space.lg),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: Space.lg),
                    itemBuilder: (_, i) => items[i],
                  );
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
              final columns = c.maxWidth >= 720 ? 4 : (c.maxWidth >= 480 ? 2 : 1);
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
    // Anything that prints as 0.0% is no change: muted and flat, not a green rise.
    final flat = (change ?? 0).abs() < 0.05;
    final trendColor = flat ? scheme.onSurfaceVariant : (up ? status.success : status.danger);
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(Radii.medium)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(Radii.control),
            ),
            child: Icon(icon, color: scheme.onPrimaryContainer, size: 20),
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
                Icon(
                  flat ? Icons.trending_flat_rounded : (up ? Icons.trending_up_rounded : Icons.trending_down_rounded),
                  size: 18,
                  color: trendColor,
                ),
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
    final alerts = conflicts > 0 || state.failedPayments > 0;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.needsAction, style: theme.textTheme.titleLarge),
          const SizedBox(height: Space.sm),
          if (state.loading && state.summary == null)
            const LinearProgressIndicator()
          else if (state.nothingToDo)
            _ActionRow(icon: Iconsax.tick_circle_copy, color: status.success, background: status.successContainer, title: l10n.nothingToDo)
          else ...[
            if (conflicts > 0)
              _ActionRow(
                icon: Iconsax.warning_2_copy,
                color: status.warning,
                background: status.warningContainer,
                title: l10n.openConflicts(conflicts),
                onTap: () => context.go('/transactions?conflicts=1'),
              ),
            if (state.failedPayments > 0)
              _ActionRow(
                icon: Iconsax.card_remove_copy,
                color: status.danger,
                background: status.dangerContainer,
                title: l10n.failedPayments(state.failedPayments),
                onTap: () => context.go('/payments?status=failed&today=1'),
              ),
            if (state.oldestDebts.isNotEmpty) ...[
              if (alerts) const Divider(height: Space.xxl) else const SizedBox(height: Space.sm),
              Text(l10n.oldestDebts, style: theme.textTheme.titleSmall),
              const SizedBox(height: Space.xs),
              for (final d in state.oldestDebts)
                _ActionRow(
                  icon: Iconsax.wallet_money_copy,
                  color: status.warning,
                  background: status.warningContainer,
                  title: d.customerName,
                  subtitle: dateText(context, d.date),
                  amount: money(context, d.remaining),
                  onTap: () => context.go('/customers/${d.customerId}'),
                ),
            ],
          ],
        ],
      ),
    );
  }
}

/// One follow-up: icon tile, what it is, an optional amount on the right and a chevron when it opens
/// something. Rows share one height so a stack of them reads as a list.
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    this.subtitle,
    this.amount,
    this.onTap,
  });
  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String? subtitle;
  final String? amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(Radii.small + 4)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (amount != null) ...[
              const SizedBox(width: Space.md),
              _Amount(amount!, theme.textTheme.titleSmall?.tabular),
            ],
            if (onTap != null) ...[
              const SizedBox(width: Space.sm),
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.items, this.full});
  final List<Transaction> items;

  /// Forces the wide or the compact columns. Null measures the card, which cannot happen inside the
  /// IntrinsicHeight rows, so the wide layout passes true.
  final bool? full;

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
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(l10n.recentTransactions, style: theme.textTheme.titleLarge),
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
            _withWidth(
              full,
              (context, full) {
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

/// Calls [builder] with [forced], or with whether the available width is at least 560 when [forced] is null.
Widget _withWidth(bool? forced, Widget Function(BuildContext context, bool wide) builder) =>
    forced != null ? Builder(builder: (context) => builder(context, forced)) : LayoutBuilder(builder: (context, c) => builder(context, c.maxWidth >= 560));

/// Best sellers by revenue. The bar is each product's revenue against the leader's, so the
/// ranking reads at a glance; the order is a real ranking, which is why the rows are numbered.
class _TopProducts extends StatelessWidget {
  const _TopProducts({required this.products});
  final List<({String name, double qty, int total})> products;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final top = products.take(5).toList();
    final leader = top.fold<int>(0, (best, p) => p.total > best ? p.total : best);
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.topProducts, style: theme.textTheme.titleLarge),
          const SizedBox(height: Space.md),
          if (top.isEmpty)
            Text(l10n.noData)
          else
            for (final (i, p) in top.indexed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text('${i + 1}', style: theme.textTheme.bodyMedium?.tabular.copyWith(color: scheme.onSurfaceVariant)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: Text(p.name, style: theme.textTheme.bodyLarge, maxLines: 2, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: Space.md),
                              _Amount(money(context, p.total), theme.textTheme.bodyMedium?.tabular),
                            ],
                          ),
                          Text(l10n.sold(formatQty(p.qty, locale: locale)), style: theme.textTheme.bodySmall),
                          const SizedBox(height: Space.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: leader == 0 ? 0 : p.total / leader,
                              minHeight: 4,
                              backgroundColor: scheme.surfaceContainerHigh,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _PaymentMix extends StatelessWidget {
  const _PaymentMix({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final payTotal = summary.paymentMethods.fold<int>(0, (a, m) => a + m.total);
    return _ListCard(
      title: l10n.paymentMix,
      rows: [
        for (final m in summary.paymentMethods)
          _ValueLine(
            methodLabel(l10n, PaymentMethod.fromWire(m.method)),
            money(context, m.total),
            sub: '${m.count}× · ${payTotal == 0 ? 0 : (m.total * 100 / payTotal).round()}%',
          ),
      ],
    );
  }
}

class _DebtFlow extends StatelessWidget {
  const _DebtFlow({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ListCard(
      title: l10n.debtFlow,
      rows: [
        _ValueLine(l10n.newDebt, money(context, summary.debtNew)),
        _ValueLine(l10n.paidDebt, money(context, summary.debtPaid)),
      ],
    );
  }
}

class _DevicesOnline extends StatelessWidget {
  const _DevicesOnline({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) => _ListCard(
    title: AppLocalizations.of(context).devicesOnline,
    rows: [for (final d in summary.devicesOnline) _ValueLine(d.platform == 'ios' ? 'iOS' : 'Android', '${d.count}')],
  );
}

/// A titled card of label and value lines; "no data" when there are none.
class _ListCard extends StatelessWidget {
  const _ListCard({required this.title, required this.rows});
  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: Space.md),
          if (rows.isEmpty) Text(AppLocalizations.of(context).noData) else ...rows,
        ],
      ),
    );
  }
}

/// Label (with an optional small line under it) on the left, value on the right edge.
class _ValueLine extends StatelessWidget {
  const _ValueLine(this.left, this.right, {this.sub});
  final String left;
  final String right;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(left, style: theme.textTheme.bodyLarge),
                if (sub != null) Text(sub!, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          _Amount(right, theme.textTheme.bodyMedium?.tabular),
        ],
      ),
    );
  }
}

/// A value on the right edge of a row. It shrinks to fit rather than overflowing when the card is
/// narrow or the text is scaled up, and never takes more than its share from the label beside it.
class _Amount extends StatelessWidget {
  const _Amount(this.text, this.style);
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) =>
      Flexible(flex: 2, child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(text, style: style)));
}
