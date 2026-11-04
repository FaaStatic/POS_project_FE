import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';

/// The cart side of a debt tab: the customer's debt, how much is paid now, the cash handed over,
/// and what is left. Paying works the same as a sale (cash, change, receipt), but there are no
/// products and no QRIS or VA.
class DebtPanel extends StatefulWidget {
  const DebtPanel({super.key, required this.draft, required this.paying, this.scrollController});
  final Draft draft;
  final bool paying;
  final ScrollController? scrollController;

  @override
  State<DebtPanel> createState() => _DebtPanelState();
}

class _DebtPanelState extends State<DebtPanel> {
  final _amount = TextEditingController();
  final _cash = TextEditingController();
  Future<Debt?>? _debt;
  String? _loadedFor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(DebtPanel old) {
    super.didUpdateWidget(old);
    if (old.draft.customerId != widget.draft.customerId) _load();
  }

  void _load() {
    final id = widget.draft.customerId;
    _loadedFor = id;
    _cash.clear();
    _amount.clear();
    _debt = id == null ? null : getIt<CatalogCache>().debtOfCustomer(id).then((d) {
      // The full debt is the starting amount; a part payment is typed over it.
      if (d != null && _loadedFor == id && mounted) _amount.text = '${d.remaining}';
      return d;
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _cash.dispose();
    super.dispose();
  }

  int get _amountValue => int.tryParse(_amount.text) ?? 0;

  /// Left empty, the cash is taken as exactly the amount.
  int get _cashValue => _cash.text.isEmpty ? _amountValue : int.tryParse(_cash.text) ?? 0;

  Future<void> _close() async => context.read<CheckoutBloc>().add(TabClosed(widget.draft.id));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final draft = widget.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(Space.sm),
          child: Row(
            children: [
              const SizedBox(width: TapSize.min),
              Expanded(
                child: Column(
                  children: [
                    Text(draftTitle(context, draft), style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                    Text(l10n.payDebtTab, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                  ],
                ),
              ),
              SizedBox(
                width: TapSize.min,
                child: IconButton(
                  tooltip: l10n.closeTab,
                  onPressed: _close,
                  style: IconButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    backgroundColor: StatusColors.of(context).dangerContainer,
                  ),
                  icon: const Icon(Iconsax.trash_copy, size: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Debt?>(
            future: _debt,
            builder: (context, snapshot) {
              final debt = snapshot.data;
              if (draft.customerId == null) return EmptyState(icon: Iconsax.user_search_copy, message: l10n.debtPickFromList);
              if (snapshot.connectionState != ConnectionState.done) return const LoadingView();
              if (debt == null) return EmptyState(icon: Iconsax.wallet_check_copy, message: l10n.debtNoDebt);
              return _form(context, debt);
            },
          ),
        ),
      ],
    );
  }

  Widget _form(BuildContext context, Debt debt) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return StatefulBuilder(
      builder: (context, setLocal) {
        final amount = _amountValue;
        final cash = _cashValue;
        final valid = amount > 0 && amount <= debt.remaining && cash >= amount;
        final left = debt.remaining - amount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(Space.lg),
                children: [
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(debt.customerName, style: theme.textTheme.titleMedium),
                        const SizedBox(height: Space.xs),
                        Text(l10n.debtTotalOwed, style: theme.textTheme.bodySmall),
                        Text(rupiah(context, debt.remaining), style: theme.textTheme.headlineSmall?.tabular),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  AppTextField(
                    label: l10n.paymentAmount,
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setLocal(() {}),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppButton(
                      label: l10n.payFull(rupiah(context, debt.remaining)),
                      variant: AppButtonVariant.ghost,
                      onPressed: () => setLocal(() => _amount.text = '${debt.remaining}'),
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  AppTextField(
                    label: l10n.cashReceived,
                    controller: _cash,
                    hint: amount > 0 ? rupiah(context, amount) : null,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setLocal(() {}),
                  ),
                  const SizedBox(height: Space.lg),
                  _Row(label: l10n.debtLeft, value: rupiah(context, left < 0 ? 0 : left), emphasis: left == 0 && amount > 0),
                  if (left == 0 && amount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Text(l10n.debtSettledLabel, style: theme.textTheme.labelLarge?.copyWith(color: StatusColors.of(context).success)),
                    ),
                  if (cash > amount && amount > 0) ...[
                    const SizedBox(height: Space.sm),
                    _Row(label: l10n.change, value: rupiah(context, cash - amount)),
                  ],
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant))),
              child: Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: AppButton(
                  label: l10n.payDebtTab,
                  large: true,
                  expand: true,
                  loading: widget.paying,
                  onPressed: valid
                      ? () => context.read<CheckoutBloc>().add(PayRequested(debtAmount: amount, amountPaid: cash))
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.emphasis = false});
  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final style = emphasis ? Theme.of(context).textTheme.titleMedium?.tabular : Theme.of(context).textTheme.bodyLarge?.tabular;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Flexible(child: Text(label, style: style)), const SizedBox(width: Space.md), Text(value, style: style)],
    );
  }
}
