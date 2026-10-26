import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';
import 'charge_view.dart';
import 'customer_picker.dart';

/// Cart of the active tab in two steps: items, then payment. Bayar stays at the
/// bottom, apart from the product list.
class CartPanel extends StatefulWidget {
  const CartPanel({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  bool _paying = false;
  int? _draftId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutBloc>().state;
    final draft = state.active;
    if (draft == null) return const LoadingView();
    // Switching tabs starts that tab at its items again.
    if (_draftId != draft.id) {
      _draftId = draft.id;
      _paying = false;
    }
    // White cards need the canvas behind them, in the sheet and the side panel alike.
    return ColoredBox(
      color: ShellColors.of(context).canvas,
      child: switch (draft.status) {
        DraftStatus.awaitingPayment => ChargeView(draft: draft),
        DraftStatus.paid => _PaidView(draft: draft),
        DraftStatus.open when _paying && !draft.isEmpty => _PaymentStep(
          draft: draft,
          state: state,
          scrollController: widget.scrollController,
          onBack: () => setState(() => _paying = false),
        ),
        DraftStatus.open => _CartStep(
          draft: draft,
          state: state,
          scrollController: widget.scrollController,
          onNext: () => setState(() => _paying = true),
        ),
      },
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.subtitle, this.leading, this.trailing});
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.sm, Space.sm),
      child: Row(
        children: [
          SizedBox(width: TapSize.min, child: leading),
          Expanded(
            child: Column(
              children: [
                Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                Text(subtitle, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
              ],
            ),
          ),
          SizedBox(width: TapSize.min, child: trailing),
        ],
      ),
    );
  }
}

class _CartStep extends StatelessWidget {
  const _CartStep({required this.draft, required this.state, required this.onNext, this.scrollController});
  final Draft draft;
  final CheckoutState state;
  final VoidCallback onNext;
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
        _StepHeader(
          title: ui.tabLabel(draft.number),
          subtitle: l10n.itemsCount(qty(context, draft.itemCount)),
          trailing: IconButton(
            tooltip: l10n.closeTab,
            onPressed: () => _close(context),
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              backgroundColor: StatusColors.of(context).dangerContainer,
            ),
            icon: const Icon(Iconsax.trash, size: 20),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: const Icon(Iconsax.user),
                  title: Text(draft.customerName ?? l10n.chooseCustomer),
                  subtitle: draft.customerName == null ? null : Text(l10n.customer),
                  trailing: Text(
                    l10n.changeCustomer,
                    style: theme.textTheme.labelLarge?.copyWith(decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    final bloc = context.read<CheckoutBloc>();
                    final picked = await showCustomerPicker(context);
                    if (picked != null) bloc.add(CustomerChanged(id: picked.id, name: picked.name));
                  },
                ),
              ),
              const SizedBox(height: Space.md),
              if (draft.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xxl),
                  child: EmptyState(icon: Iconsax.shopping_cart, message: l10n.cartEmpty),
                )
              else
                for (final item in draft.items) ...[
                  _CartLine(
                    key: ValueKey(item.id),
                    item: item,
                    debt: debt,
                    stockLeft: state.shortfalls[item.productId],
                  ),
                  const SizedBox(height: Space.sm),
                ],
            ],
          ),
        ),
        _BottomBar(
          children: [
            _SummaryRow(
              label: l10n.total,
              value: rupiah(context, draft.total(debt: debt)),
              strong: true,
            ),
            const SizedBox(height: Space.md),
            AppButton(
              label: l10n.toPayment,
              icon: Iconsax.card,
              large: true,
              expand: true,
              onPressed: draft.isEmpty ? null : onNext,
            ),
          ],
        ),
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
    final unit = ProductUnit.values[item.unit.clamp(0, ProductUnit.values.length - 1)].name;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, Space.md, Space.sm, Space.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InitialAvatar(name: item.name, size: 44),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.titleSmall),
                      Text(
                        '${qty(context, item.qty)} × ${rupiah(context, item.price(debt: debt))} / $unit',
                        style: theme.textTheme.bodySmall?.tabular,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(TapSize.min, 40),
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          textStyle: theme.textTheme.bodySmall?.copyWith(decoration: TextDecoration.underline),
                        ),
                        onPressed: () => bloc.add(ItemRemoved(item.id)),
                        child: Text(l10n.remove),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Text(rupiah(context, item.subtotal(debt: debt)), style: theme.textTheme.titleSmall?.tabular),
                  ],
                ),
              ],
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
                padding: const EdgeInsets.only(top: Space.sm),
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
          ],
        ),
      ),
    );
  }
}

String? _disabledReason(AppLocalizations l10n, CheckoutState state, Draft draft, PaymentMethod m) => switch (m) {
  PaymentMethod.qris || PaymentMethod.va when !state.online => l10n.needsInternet,
  PaymentMethod.qris || PaymentMethod.va when draft.hasDigital => l10n.digitalCashOnly,
  PaymentMethod.debt when draft.customerId == null => l10n.debtNeedsCustomer,
  _ => null,
};

class _PaymentStep extends StatefulWidget {
  const _PaymentStep({required this.draft, required this.state, required this.onBack, this.scrollController});
  final Draft draft;
  final CheckoutState state;
  final VoidCallback onBack;
  final ScrollController? scrollController;

  @override
  State<_PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<_PaymentStep> {
  final _received = TextEditingController();

  @override
  void dispose() {
    _received.dispose();
    super.dispose();
  }

  /// "Uang pas" plus the next round notes a buyer is likely to hand over.
  static List<int> _suggestions(int total) {
    final out = <int>{total};
    for (final step in [5000, 10000, 20000, 50000, 100000]) {
      final up = ((total + step - 1) ~/ step) * step;
      if (up > total) out.add(up);
      if (out.length >= 4) break;
    }
    return out.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final shell = ShellColors.of(context);
    final status = StatusColors.of(context);
    final draft = widget.draft;
    final state = widget.state;
    final bloc = context.read<CheckoutBloc>();
    final total = draft.total(debt: state.method == PaymentMethod.debt);
    final reason = _disabledReason(l10n, state, draft, state.method);
    final received = int.tryParse(_received.text) ?? 0;
    final cash = state.method == PaymentMethod.cash;
    final short = cash && received > 0 && received < total;

    final methods = [
      (PaymentMethod.cash, Iconsax.money, l10n.cashHint),
      (PaymentMethod.debt, Iconsax.note_text, l10n.debtHint),
      (PaymentMethod.qris, Iconsax.scan_barcode, l10n.qrisHint),
      (PaymentMethod.va, Iconsax.bank, l10n.vaHint2),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeader(
          title: l10n.payment,
          subtitle: UiLocalizations.of(context).tabLabel(draft.number),
          leading: IconButton(tooltip: l10n.back, onPressed: widget.onBack, icon: const Icon(Icons.arrow_back_rounded)),
        ),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
            children: [
              Container(
                padding: const EdgeInsets.all(Space.xl),
                decoration: BoxDecoration(color: shell.background, borderRadius: BorderRadius.circular(Radii.large)),
                child: Column(
                  children: [
                    Text(l10n.totalAmount, style: theme.textTheme.bodyMedium?.copyWith(color: shell.muted)),
                    const SizedBox(height: Space.xs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        rupiah(context, total),
                        style: theme.textTheme.displaySmall?.tabular.copyWith(color: shell.foreground),
                      ),
                    ),
                    const SizedBox(height: Space.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: shell.indicator),
                        const SizedBox(width: Space.sm),
                        Flexible(
                          child: Text(
                            [l10n.itemsCount(qty(context, draft.itemCount)), ?draft.customerName].join(' · '),
                            style: theme.textTheme.bodyMedium?.copyWith(color: shell.foreground),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.xl),
              Text(l10n.method, style: theme.textTheme.titleSmall),
              const SizedBox(height: Space.sm),
              for (final (m, icon, hint) in methods) ...[
                _MethodCard(
                  icon: icon,
                  title: methodLabel(l10n, m),
                  subtitle: _disabledReason(l10n, state, draft, m) ?? hint,
                  selected: state.method == m,
                  enabled: _disabledReason(l10n, state, draft, m) == null,
                  onTap: () => bloc.add(MethodChanged(m)),
                ),
                const SizedBox(height: Space.sm),
              ],
              if (state.method == PaymentMethod.va && reason == null) ...[
                const SizedBox(height: Space.sm),
                Text(l10n.chooseBank, style: theme.textTheme.titleSmall),
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
              if (cash) ...[
                const SizedBox(height: Space.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: Space.sm,
                          runSpacing: Space.sm,
                          children: [
                            for (final v in _suggestions(total))
                              ChoiceChip(
                                label: Text(v == total ? l10n.exactAmount : rupiah(context, v)),
                                selected: received == v,
                                onSelected: (_) => setState(() => _received.text = '$v'),
                              ),
                          ],
                        ),
                        const SizedBox(height: Space.md),
                        AppTextField(
                          label: l10n.cashReceived,
                          prefixIcon: Iconsax.money,
                          controller: _received,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (_) => setState(() {}),
                        ),
                        if (received > 0) ...[
                          const Divider(height: Space.xl),
                          _SummaryRow(
                            label: short ? l10n.shortBy(rupiah(context, total - received)) : l10n.change,
                            value: short ? '' : rupiah(context, received - total),
                            color: short ? status.danger : status.success,
                            strong: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        _BottomBar(
          children: [
            AppButton(
              label: l10n.payAmount(rupiah(context, total)),
              icon: Iconsax.tick_circle,
              large: true,
              expand: true,
              loading: state.paying,
              onPressed: reason != null || short ? null : () => bloc.add(PayRequested(bank: state.vaBank)),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = selected ? scheme.onPrimary : (enabled ? scheme.onSurface : scheme.onSurfaceVariant);
    final sub = selected ? scheme.onPrimary.withValues(alpha: 0.7) : scheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      enabled: enabled,
      child: Card(
        color: selected ? scheme.primary : null,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? scheme.onPrimary.withValues(alpha: 0.12) : scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(Radii.small + 4),
                  ),
                  child: Icon(icon, color: fg, size: 22),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall?.copyWith(color: fg)),
                      Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: sub)),
                    ],
                  ),
                ),
                if (selected) Icon(Icons.check_circle_rounded, color: scheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.strong = false, this.color});
  final String label;
  final String value;
  final bool strong;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(label, style: (strong ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium)?.copyWith(color: color)),
        Text(
          value,
          style: (strong ? theme.textTheme.headlineSmall : theme.textTheme.bodyLarge)?.tabular.copyWith(color: color),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
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
