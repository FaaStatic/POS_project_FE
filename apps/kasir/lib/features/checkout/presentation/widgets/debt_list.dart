import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/labels.dart';
import '../../../../common/pull_refresh.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';

/// Stands in for the product list while a debt tab is active: customers with an open debt,
/// from the device cache. Tapping one sets it as the tab's customer.
class DebtPane extends StatelessWidget {
  const DebtPane({super.key, this.header});

  /// Scrolls away above the search when the screen is short.
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final debts = context.read<DebtsCubit>();
    final picked = context.select<CheckoutBloc, String?>((b) => b.state.active?.customerId);
    return PullRefresh(
      child: CustomScrollView(
        physics: PullRefresh.physics,
        slivers: [
          if (header case final header?) SliverToBoxAdapter(key: const ValueKey('tabs'), child: header),
          SliverToBoxAdapter(
            key: const ValueKey('search'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.sm),
              child: SearchField(hint: l10n.searchDebtCustomers, onChanged: debts.search),
            ),
          ),
          BlocBuilder<DebtsCubit, DebtsState>(
            builder: (context, state) {
              if (state.loading) return const SliverFillRemaining(hasScrollBody: false, child: LoadingView());
              if (state.debts.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(icon: Iconsax.wallet_check_copy, message: l10n.debtsEmpty),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
                sliver: SliverList.separated(
                  itemCount: state.debts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
                  itemBuilder: (context, i) {
                    final debt = state.debts[i];
                    return _DebtTile(
                      key: ValueKey(debt.id),
                      debt: debt,
                      selected: debt.customerId == picked,
                      onTap: () => context.read<CheckoutBloc>().add(CustomerChanged(id: debt.customerId, name: debt.customerName)),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({super.key, required this.debt, required this.selected, required this.onTap});
  final Debt debt;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: selected ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        selected: selected,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
        onTap: onTap,
        title: Text(debt.customerName, style: theme.textTheme.titleSmall),
        // Under the name, not trailing: a large amount at large text would crowd the name out.
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rupiah(context, debt.remaining), style: theme.textTheme.titleMedium?.tabular),
            Text(l10n.remaining(rupiah(context, debt.remaining), rupiah(context, debt.total)), style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
