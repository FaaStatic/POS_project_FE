import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/kasir_page.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
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
            if (state.sales.isEmpty) return EmptyState(icon: Iconsax.receipt_2_copy, message: l10n.historyEmpty);
            return ListView.separated(
              padding: const EdgeInsets.all(Space.lg),
              itemCount: state.sales.length,
              separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
              itemBuilder: (context, i) => SaleTile(key: ValueKey(state.sales[i].clientRef), sale: state.sales[i]),
            );
          },
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
