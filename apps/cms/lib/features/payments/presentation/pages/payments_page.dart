import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/feedback.dart';
import '../../../../common/labels.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/payments_cubit.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key, this.initial = const PaymentQuery()});
  final PaymentQuery initial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => PaymentsCubit(getIt(), getIt(), initial: initial)..load(),
      child: Builder(builder: (context) {
        final cubit = context.read<PaymentsCubit>();
        final state = context.watch<PaymentsCubit>().state;
        final theme = Theme.of(context);
        final q = cubit.query;
        return CmsPage(
          title: l10n.paymentsTitle,
          body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [FilterBar(children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<PaymentState?>(
                  isExpanded: true,
                  initialValue: q.state,
                  decoration: InputDecoration(labelText: l10n.status),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.allStatuses)),
                    for (final s in PaymentState.values) DropdownMenuItem(value: s, child: Text(paymentStateLabel(l10n, s))),
                  ],
                  onChanged: cubit.filterState,
                ),
              ),
              SegmentedButton<ChargeMethod?>(
                segments: [
                  ButtonSegment(value: null, label: Text(l10n.allMethods)),
                  ButtonSegment(value: ChargeMethod.qris, label: Text(l10n.qris)),
                  ButtonSegment(value: ChargeMethod.va, label: Text(l10n.va)),
                ],
                selected: {q.method},
                onSelectionChanged: (s) => cubit.method(s.first),
              ),
              DateRangeField(
                value: q.dateStart == null ? null : DateTimeRange(start: q.dateStart!, end: q.dateEnd ?? q.dateStart!),
                onChanged: (r) => cubit.dates(r?.start, r?.end),
              ),
            ]),
            Expanded(
              child: PagedBody<PaymentRecord>(
                state: state,
                emptyMessage: l10n.paymentsEmpty,
                onRetry: cubit.load,
                builder: (items) => ResponsiveTable<PaymentRecord>(
                  rows: items,
                  rowKey: (p) => p.id,
                  hasMore: state.hasNext,
                  loadingMore: state.loadingMore,
                  onLoadMore: cubit.loadMore,
                  columns: [
                    TableColumnSpec(label: l10n.orderId, flex: 2, cell: (_, p) => Text(p.orderId, style: theme.textTheme.bodyMedium?.tabular)),
                    TableColumnSpec(label: l10n.method, cell: (_, p) => Text(p.method == ChargeMethod.qris ? l10n.qris : '${l10n.va} ${(p.vaBank ?? '').toUpperCase()}')),
                    TableColumnSpec(label: l10n.status, cell: (_, p) => StatusBadge(label: paymentStateLabel(l10n, p.state), tone: paymentStateTone(p.state))),
                    TableColumnSpec(label: l10n.amount, numeric: true, cell: (c, p) => Text(money(c, p.grossAmount), style: theme.textTheme.bodyMedium?.tabular)),
                    TableColumnSpec(label: l10n.fee, numeric: true, secondary: true, cell: (c, p) => Text(money(c, p.feeAmount), style: theme.textTheme.bodyMedium?.tabular)),
                    TableColumnSpec(label: l10n.createdAt, secondary: true, cell: (c, p) => Text(dateTimeText(c, p.createdAt))),
                    TableColumnSpec(label: l10n.paidAt, secondary: true, cell: (c, p) => Text(dateTimeText(c, p.paidAt))),
                  ],
                  actions: (context, p) => OutlinedButton(
                    onPressed: () async {
                      final result = await cubit.check(p);
                      if (!context.mounted) return;
                      showResult(context, result, switch (result) {
                        Ok(:final value) => l10n.statusChecked(paymentStateLabel(l10n, value.state)),
                        Err() => '',
                      });
                    },
                    child: Text(l10n.checkStatus),
                  ),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
