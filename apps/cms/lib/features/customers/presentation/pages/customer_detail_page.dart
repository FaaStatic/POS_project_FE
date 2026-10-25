import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/customers_cubit.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<CustomerDetailCubit>()..load(customerId),
      child: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
        builder: (context, state) {
          final c = state.customer;
          return Scaffold(
            appBar: AppBar(title: Text(c?.name ?? l10n.customerDetail)),
            body: state.loading
                ? const LoadingView()
                : c == null
                ? ErrorState(
                    message: failureText(context, state.failure!),
                    onRetry: () => context.read<CustomerDetailCubit>().load(customerId),
                  )
                : ConstrainedBody(
                    padding: const EdgeInsets.all(Space.lg),
                    maxWidth: 880,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListView(
                        padding: const EdgeInsets.all(Space.xl),
                        children: [
                          Wrap(
                            spacing: Space.md,
                            children: [
                              if (!c.active) StatusBadge(label: l10n.inactive),
                              if (c.phone.isNotEmpty) Text(c.phone, style: theme.textTheme.bodyLarge),
                              if (c.address.isNotEmpty) Text(c.address, style: theme.textTheme.bodyLarge),
                            ],
                          ),
                          const SizedBox(height: Space.xxl),
                          Text(l10n.debtsTitle, style: theme.textTheme.titleMedium),
                          const SizedBox(height: Space.sm),
                          if (c.debts.isEmpty) Text(l10n.noDebts),
                          for (final d in c.debts)
                            ListTile(
                              key: ValueKey(d.id),
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${money(context, d.remaining)} / ${money(context, d.total)}',
                                style: theme.textTheme.bodyLarge?.tabular,
                              ),
                              subtitle: Text(dateText(context, d.date)),
                              trailing: StatusBadge(
                                label: d.paid ? l10n.debtPaid : l10n.debtUnpaid,
                                tone: d.paid ? BadgeTone.success : BadgeTone.warning,
                              ),
                            ),
                          const SizedBox(height: Space.xxl),
                          Text(l10n.transactionsTitle, style: theme.textTheme.titleMedium),
                          const SizedBox(height: Space.sm),
                          if (state.transactions.isEmpty) Text(l10n.noTransactions),
                          for (final t in state.transactions)
                            ListTile(
                              key: ValueKey(t.id),
                              contentPadding: EdgeInsets.zero,
                              title: Text(t.invoice, style: theme.textTheme.bodyLarge?.tabular),
                              subtitle: Text(dateTimeText(context, t.createdAt)),
                              trailing: Text(money(context, t.total), style: theme.textTheme.titleSmall?.tabular),
                            ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
