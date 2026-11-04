import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/pull_refresh.dart';
import '../../../../app/shell/kasir_page.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../sync/presentation/bloc/sync_cubit.dart';
import '../bloc/history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..start(),
      child: KasirPage(
        title: l10n.historyTitle,
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state.loading) return const LoadingView();
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(tabs: [Tab(text: l10n.historySalesTab), Tab(text: l10n.historyDebtTab)]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _SaleList(sales: state.sales.where((s) => !s.isDebtPayment).toList(), empty: l10n.historyEmpty),
                        _DebtPayments(local: state.sales.where((s) => s.isDebtPayment).toList(), others: state.otherPayments),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SaleList extends StatelessWidget {
  const _SaleList({required this.sales, required this.empty});
  final List<Sale> sales;
  final String empty;

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) return EmptyState(icon: Iconsax.receipt_2_copy, message: empty);
    return PullRefresh(
      child: ListView.separated(
        physics: PullRefresh.physics,
        padding: const EdgeInsets.all(Space.lg),
        itemCount: sales.length,
        separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
        itemBuilder: (context, i) => SaleTile(key: ValueKey(sales[i].clientRef), sale: sales[i]),
      ),
    );
  }
}

/// Debt payments of this device (tap for the receipt) and the ones the server knows from
/// elsewhere (other registers, the CMS), newest first. Pulling also re-reads the server's list.
class _DebtPayments extends StatelessWidget {
  const _DebtPayments({required this.local, required this.others});
  final List<Sale> local;
  final List<DebtPaymentEntry> others;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(DateTime, Object)>[
      for (final s in local) (s.createdAt, s),
      for (final p in others) (p.paidAt?.toLocal() ?? DateTime.fromMillisecondsSinceEpoch(0), p),
    ]..sort((a, b) => b.$1.compareTo(a.$1));
    if (items.isEmpty) return EmptyState(icon: Iconsax.receipt_2_copy, message: l10n.historyDebtEmpty);
    final cubit = context.read<HistoryCubit>();
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<SyncCubit>().syncNow(quiet: true, pullCatalog: true);
        await cubit.refreshPayments();
      },
      child: ListView.separated(
        physics: PullRefresh.physics,
        padding: const EdgeInsets.all(Space.lg),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
        itemBuilder: (context, i) => switch (items[i].$2) {
          final Sale sale => SaleTile(key: ValueKey(sale.clientRef), sale: sale),
          final DebtPaymentEntry payment => _RemotePaymentTile(key: ValueKey(payment.id), payment: payment),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _RemotePaymentTile extends StatelessWidget {
  const _RemotePaymentTile({super.key, required this.payment});
  final DebtPaymentEntry payment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final at = payment.paidAt;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
        title: Text(payment.customerName, style: theme.textTheme.titleSmall),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: Space.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Space.xs,
            children: [
              Text(rupiah(context, payment.amount), style: theme.textTheme.titleMedium?.tabular),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (at != null) Text(formatDateTime(at.toLocal(), locale: Localizations.localeOf(context).languageCode)),
                  if (payment.cashier.isNotEmpty) Text(payment.cashier),
                  StatusBadge(
                    label: payment.paid ? l10n.debtSettledLabel : l10n.debtLeftAmount(rupiah(context, payment.remaining)),
                    tone: payment.paid ? BadgeTone.success : BadgeTone.warning,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaleTile extends StatelessWidget {
  const SaleTile({super.key, required this.sale});
  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
        onTap: () => context.push('/sale/${sale.clientRef}'),
        title: Text(sale.receiptNumber, style: theme.textTheme.titleSmall?.tabular),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: Space.xs),
          child: Wrap(
            spacing: Space.sm,
            runSpacing: Space.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (sale.isDebtPayment && sale.customerName != null) Text(sale.customerName!),
              Text(
                '${formatDateTime(sale.createdAt, locale: Localizations.localeOf(context).languageCode)} · ${methodLabel(l10n, sale.method)}',
              ),
              SaleStatusBadge(sale: sale),
              if (sale.stockConflict) StatusBadge(label: l10n.stockConflict, tone: BadgeTone.warning),
            ],
          ),
        ),
        trailing: Text(rupiah(context, sale.total), style: theme.textTheme.titleMedium?.tabular),
      ),
    );
  }
}

class SaleStatusBadge extends StatelessWidget {
  const SaleStatusBadge({super.key, required this.sale});
  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (sale.status) {
      SaleStatus.pending => StatusBadge(label: l10n.statusPending, tone: BadgeTone.warning, icon: Iconsax.cloud_change_copy),
      SaleStatus.synced => StatusBadge(label: l10n.statusSynced, tone: BadgeTone.success),
      SaleStatus.failed => StatusBadge(label: l10n.statusFailed, tone: BadgeTone.danger),
      SaleStatus.cancelled => StatusBadge(label: l10n.statusCancelled),
    };
  }
}
