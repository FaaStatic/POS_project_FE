import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/add_debt_form.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/feedback.dart';
import '../../../../common/file_saver.dart';
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
                          _SectionHeader(
                            title: l10n.debtsTitle,
                            trailing: c.active
                                ? IconAction(
                                    icon: Iconsax.wallet_add_copy,
                                    tooltip: l10n.addDebt,
                                    onPressed: () async {
                                      final cubit = context.read<CustomerDetailCubit>();
                                      final saved = await showAddDebt(
                                        context,
                                        customer: c,
                                        current: state.openDebt?.remaining ?? 0,
                                        submit: cubit.addDebt,
                                      );
                                      if (saved && context.mounted) toast(context, l10n.debtAdded);
                                    },
                                  )
                                : null,
                          ),
                          if (state.openDebt case final d?)
                            Padding(
                              key: ValueKey(d.id),
                              padding: const EdgeInsets.only(top: Space.sm),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: Space.md,
                                runSpacing: Space.xs,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(money(context, d.remaining), style: theme.textTheme.headlineSmall?.tabular),
                                      Text(
                                        '${l10n.total} ${money(context, d.total)} · ${dateText(context, d.date)}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  StatusBadge(
                                    label: d.paid ? l10n.debtPaid : l10n.debtUnpaid,
                                    tone: d.paid ? BadgeTone.success : BadgeTone.warning,
                                  ),
                                ],
                              ),
                            )
                          else
                            Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l10n.noDebts)),
                          const SizedBox(height: Space.xxl),
                          _SectionHeader(title: l10n.debtPaymentsTitle),
                          const SizedBox(height: Space.xs),
                          if (state.payments.isEmpty)
                            Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l10n.noDebtPayments)),
                          for (final p in state.payments)
                            _PaymentRow(
                              key: ValueKey(p.id),
                              payment: p,
                              onReceipt: () async {
                                final result = await context.read<CustomerDetailCubit>().receipt(p.id);
                                if (!context.mounted) return;
                                if (result case Ok(value: (final bytes, final name))) saveFile(bytes, name);
                                showResult(context, result, l10n.downloaded);
                              },
                            ),
                          const SizedBox(height: Space.xxl),
                          _SectionHeader(title: l10n.transactionsTitle),
                          const SizedBox(height: Space.xs),
                          if (state.transactions.isEmpty)
                            Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l10n.noTransactions)),
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

/// Section title with one optional trailing action, the same rhythm for every block on the page.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant))),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
          ?trailing,
        ],
      ),
    );
  }
}

/// One installment: when and who took it on the left, what was paid and what is left on the right.
class _PaymentRow extends StatelessWidget {
  const _PaymentRow({super.key, required this.payment, required this.onReceipt});
  final DebtPaymentEntry payment;
  final VoidCallback onReceipt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateTimeText(context, payment.paidAt), style: theme.textTheme.bodyLarge),
                Text(
                  '${l10n.cashierName}: ${payment.cashier.isEmpty ? l10n.paidViaCms : payment.cashier}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(money(context, payment.amount), style: theme.textTheme.titleSmall?.tabular),
              Text('${l10n.balanceLeft} ${money(context, payment.remaining)}', style: theme.textTheme.bodySmall?.tabular),
              const SizedBox(height: Space.xs),
              StatusBadge(
                label: payment.paid ? l10n.debtPaid : l10n.debtUnpaid,
                tone: payment.paid ? BadgeTone.success : BadgeTone.warning,
              ),
            ],
          ),
          IconAction(icon: Iconsax.document_download_copy, tooltip: l10n.downloadDebtReceipt, onPressed: onReceipt),
        ],
      ),
    );
  }
}
