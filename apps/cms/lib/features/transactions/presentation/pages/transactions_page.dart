import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/labels.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/transactions_cubit.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key, this.conflictsOnly = false});

  /// Opened from the dashboard's "needs action" row.
  final bool conflictsOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => TransactionsCubit(getIt(), conflictsOnly: conflictsOnly)..load(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<TransactionsCubit>();
          final state = context.watch<TransactionsCubit>().state;
          final theme = Theme.of(context);
          final q = cubit.query;
          return CmsPage(
            title: l10n.transactionsTitle,
            body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [FilterBar(
                  children: [
                    FilterField(
                      label: l10n.date,
                      child: DateRangeField(
                        value: q.dateStart == null
                            ? null
                            : DateTimeRange(start: q.dateStart!, end: q.dateEnd ?? q.dateStart!),
                        onChanged: (r) => cubit.dates(r?.start, r?.end),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: AppSelect<PaymentMethod?>(
                        label: l10n.method,
                        value: q.method,
                        choices: [
                          Choice(null, l10n.allMethods),
                          for (final m in PaymentMethod.values) Choice(m, methodLabel(l10n, m)),
                        ],
                        onChanged: cubit.method,
                      ),
                    ),
                    SizedBox(
                      width: 260,
                      child: FilterField(
                        label: l10n.search,
                        child: SearchField(hint: l10n.searchInvoice, onChanged: cubit.invoice),
                      ),
                    ),
                    FilterField(
                      child: ShadSwitch(label: Text(l10n.conflictOnly), value: q.openConflict, onChanged: cubit.conflicts),
                    ),
                  ],
                ),
                Expanded(
                  child: PagedBody<Transaction>(
                    state: state,
                    emptyMessage: l10n.transactionsEmpty,
                    onRetry: cubit.load,
                    builder: (items) => ResponsiveTable<Transaction>(
                      rows: items,
                      rowKey: (t) => t.id,
                      onTap: (t) => context.push('/transactions/${t.id}'),
                      hasMore: state.hasNext,
                      loadingMore: state.loadingMore,
                      onLoadMore: cubit.loadMore,
                      columns: [
                        TableColumnSpec(
                          label: l10n.invoice,
                          flex: 2,
                          cell: (_, t) => Text(t.invoice, style: theme.textTheme.bodyMedium?.tabular),
                        ),
                        TableColumnSpec(label: l10n.date, flex: 2, cell: (c, t) => Text(dateTimeText(c, t.createdAt))),
                        TableColumnSpec(label: l10n.method, cell: (_, t) => Text(methodLabel(l10n, t.method))),
                        TableColumnSpec(
                          label: l10n.total,
                          numeric: true,
                          cell: (c, t) => Text(money(c, t.total), style: theme.textTheme.bodyMedium?.tabular),
                        ),
                        TableColumnSpec(
                          label: l10n.profit,
                          numeric: true,
                          secondary: true,
                          cell: (c, t) => Text(money(c, t.profit), style: theme.textTheme.bodyMedium?.tabular),
                        ),
                        TableColumnSpec(
                          label: l10n.status,
                          cell: (_, t) => t.stockConflict
                              ? StatusBadge(
                                  label: t.conflictReviewed ? l10n.reviewed : l10n.conflict,
                                  tone: t.conflictReviewed ? BadgeTone.neutral : BadgeTone.warning,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
