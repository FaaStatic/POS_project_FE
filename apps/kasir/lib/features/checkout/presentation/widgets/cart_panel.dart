import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';
import 'charge_view.dart';
import 'customer_picker.dart';

/// Cart of the active tab: customer, lines, method, and the Bayar button kept
/// at the bottom, apart from the product list.
class CartPanel extends StatelessWidget {
  const CartPanel({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutBloc>().state;
    final draft = state.active;
    if (draft == null) return const LoadingView();
    return switch (draft.status) {
      DraftStatus.awaitingPayment => ChargeView(draft: draft),
      DraftStatus.paid => _PaidView(draft: draft),
      DraftStatus.open => _OpenCart(draft: draft, state: state, scrollController: scrollController),
    };
  }
}

class _OpenCart extends StatelessWidget {
  const _OpenCart({required this.draft, required this.state, this.scrollController});
  final Draft draft;
  final CheckoutState state;
  final ScrollController? scrollController;

  Future<void> _close(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<CheckoutBloc>();
    if (!draft.isEmpty) {
      final ok = await showConfirmDialog(
        context,
        title: l10n.closeTabTitle(draft.number, qty(context, draft.itemCount)),
        confirmLabel: l10n.remove,
        destructive: true,
      );
      if (!ok) return;
    }
    bloc.add(TabClosed(draft.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ui = UiLocalizations.of(context);
    final theme = Theme.of(context);
    final debt = state.method == PaymentMethod.debt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.sm, 0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(ui.tabLabel(draft.number), style: theme.textTheme.titleMedium),
                      TextButton.icon(
                        onPressed: () => _close(context),
                        icon: const Icon(Iconsax.trash, size: 20),
                        label: Text(l10n.closeTab),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  leading: const Icon(Iconsax.user),
                  title: Text(draft.customerName ?? l10n.chooseCustomer),
                  subtitle: draft.customerName == null ? null : Text(l10n.customer),
                  trailing: Text(
                    l10n.changeCustomer,
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                  ),
                  onTap: () async {
                    final bloc = context.read<CheckoutBloc>();
                    final picked = await showCustomerPicker(context);
                    if (picked != null) bloc.add(CustomerChanged(id: picked.id, name: picked.name));
                  },
                ),
              ),
              const SliverToBoxAdapter(child: Divider()),
              if (draft.isEmpty)
                SliverToBoxAdapter(
                  child: EmptyState(icon: Iconsax.shopping_cart, message: l10n.cartEmpty),
                )
              else
                SliverList.separated(
                  itemCount: draft.items.length,
                  separatorBuilder: (_, _) => const Divider(indent: Space.lg),
                  itemBuilder: (context, i) => _CartLine(
                    key: ValueKey(draft.items[i].id),
                    item: draft.items[i],
                    debt: debt,
                    stockLeft: state.shortfalls[draft.items[i].productId],
                  ),
                ),
              SliverToBoxAdapter(
                child: _PayOptions(draft: draft, state: state),
              ),
            ],
          ),
        ),
        _PayButton(draft: draft, state: state),
      ],
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({super.key, required this.item, required this.debt, this.stockLeft});
  final DraftItem item;
  final bool debt;

  /// Set when the cached stock is below the quantity in this tab.
  final double? stockLeft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bloc = context.read<CheckoutBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(item.name, style: theme.textTheme.titleSmall)),
              Text(rupiah(context, item.subtotal(debt: debt)), style: theme.textTheme.titleSmall?.tabular),
            ],
          ),
          Text(
            '${rupiah(context, item.price(debt: debt))} / ${ProductUnit.values[item.unit.clamp(0, ProductUnit.values.length - 1)].name}',
            style: theme.textTheme.bodySmall?.tabular,
          ),
          if (item.isDigital)
            Padding(
              padding: const EdgeInsets.only(top: Space.sm),
              child: AppTextField(
                key: ValueKey('dest-${item.id}'),
                label: l10n.destination,
                initialValue: item.destination,
                keyboardType: TextInputType.phone,
                errorText: item.missingDestination ? l10n.destinationRequired : null,
                onChanged: (v) => bloc.add(DestinationChanged(item.id, v)),
              ),
            ),
          if (stockLeft != null)
            Padding(
              padding: const EdgeInsets.only(top: Space.xs),
              child: Row(
                children: [
                  Icon(Iconsax.warning_2, size: 18, color: StatusColors.of(context).warning),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Text(
                      l10n.stockShort(qty(context, stockLeft!)),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: Space.xs),
          Row(
            children: [
              QtyStepper(
                value: item.qty,
                itemName: item.name,
                allowFraction:
                    item.unit == ProductUnit.kg.index ||
                    item.unit == ProductUnit.liter.index ||
                    item.unit == ProductUnit.gram.index,
                onChanged: (q) => bloc.add(QtyChanged(item.id, q)),
              ),
              const Spacer(),
              TextButton(onPressed: () => bloc.add(ItemRemoved(item.id)), child: Text(l10n.remove)),
            ],
          ),
        ],
      ),
    );
  }
}

String? _disabledReason(AppLocalizations l10n, CheckoutState state, Draft draft, PaymentMethod m) => switch (m) {
  PaymentMethod.qris || PaymentMethod.va when !state.online => l10n.needsInternet,
  PaymentMethod.qris || PaymentMethod.va when draft.hasDigital => l10n.digitalCashOnly,
  _ => null,
};

/// Method, VA bank, and total; scrolls with the cart.
class _PayOptions extends StatelessWidget {
  const _PayOptions({required this.draft, required this.state});
  final Draft draft;
  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bloc = context.read<CheckoutBloc>();
    final total = draft.total(debt: state.method == PaymentMethod.debt);
    final reason = _disabledReason(l10n, state, draft, state.method);

    return Container(
      margin: const EdgeInsets.only(top: Space.md),
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.method, style: theme.textTheme.labelLarge),
          const SizedBox(height: Space.sm),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final m in PaymentMethod.values)
                ChoiceChip(
                  label: Text(methodLabel(l10n, m)),
                  selected: state.method == m,
                  onSelected: _disabledReason(l10n, state, draft, m) == null ? (_) => bloc.add(MethodChanged(m)) : null,
                ),
            ],
          ),
          if (state.method == PaymentMethod.va && reason == null) ...[
            const SizedBox(height: Space.md),
            Text(l10n.chooseBank, style: theme.textTheme.labelLarge),
            const SizedBox(height: Space.sm),
            Wrap(
              spacing: Space.sm,
              children: [
                for (final b in VaBank.values)
                  ChoiceChip(
                    label: Text(b.name.toUpperCase()),
                    selected: state.vaBank == b,
                    onSelected: (_) => bloc.add(VaBankChanged(b)),
                  ),
              ],
            ),
          ],
          if (!state.online || draft.hasDigital) ...[
            const SizedBox(height: Space.sm),
            Text(
              [
                if (!state.online) '${l10n.qris}/${l10n.va}: ${l10n.needsInternet}',
                if (draft.hasDigital && state.online) l10n.digitalCashOnly,
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (state.method == PaymentMethod.debt && draft.customerId == null) ...[
            const SizedBox(height: Space.sm),
            Text(l10n.debtNeedsCustomer, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: Space.md),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(l10n.total, style: theme.textTheme.titleMedium),
              Text(rupiah(context, total), style: theme.textTheme.headlineSmall?.tabular),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pinned at the bottom, apart from the product list (POS guidance in PRD §7).
class _PayButton extends StatelessWidget {
  const _PayButton({required this.draft, required this.state});
  final Draft draft;
  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reason = _disabledReason(l10n, state, draft, state.method);
    final total = draft.total(debt: state.method == PaymentMethod.debt);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.lg),
          child: AppButton(
            label: l10n.payAmount(rupiah(context, total)),
            large: true,
            expand: true,
            loading: state.paying,
            onPressed: draft.isEmpty || reason != null
                ? null
                : () => context.read<CheckoutBloc>().add(PayRequested(bank: state.vaBank)),
          ),
        ),
      ),
    );
  }
}

class _PaidView extends StatelessWidget {
  const _PaidView({required this.draft});
  final Draft draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Iconsax.tick_circle, size: 48, color: StatusColors.of(context).success),
          const SizedBox(height: Space.md),
          Text(l10n.chargePaid(draft.number), textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
          const SizedBox(height: Space.xl),
          if (draft.paidSaleRef != null)
            AppButton(
              label: l10n.receipt,
              variant: AppButtonVariant.outline,
              expand: true,
              onPressed: () => context.push('/sale/${draft.paidSaleRef}'),
            ),
          const SizedBox(height: Space.md),
          AppButton(
            label: l10n.done,
            large: true,
            expand: true,
            onPressed: () => context.read<CheckoutBloc>().add(TabClosed(draft.id)),
          ),
        ],
      ),
    );
  }
}
