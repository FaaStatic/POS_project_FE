import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/labels.dart';
import '../../../../common/scrolls_when_short.dart';
import '../../../../common/tablet_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/cart_panel.dart';
import '../widgets/close_tab.dart';
import '../widgets/debt_list.dart';
import '../widgets/open_tabs_sheet.dart';
import '../widgets/product_list.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Future<void> _scan(BuildContext context) async {
    final bloc = context.read<CheckoutBloc>();
    final code = await context.push<String>('/scan');
    if (code != null) bloc.add(BarcodeSubmitted(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductsCubit>()..start(pageSize: 30)),
        BlocProvider(create: (_) => getIt<DebtsCubit>()..search('')),
      ],
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<CheckoutBloc, CheckoutState>(
            buildWhen: (a, b) => a.drafts != b.drafts || a.activeId != b.activeId || a.loading != b.loading,
            builder: (context, state) {
              if (state.loading) return const LoadingView();
              final strip = TransactionTabStrip(
                tabs: [
                  for (final d in state.drafts)
                    TransactionTab(
                      id: d.id,
                      number: d.number,
                      label: d.isDebtPayment ? draftTitle(context, d) : null,
                      highlight: d.status != DraftStatus.open,
                      subtitle: draftSubtitle(context, d),
                      // A tab waiting on QRIS/VA cannot be dropped, and the only empty sale tab would just come back.
                      closable: d.status != DraftStatus.awaitingPayment && !(state.drafts.length == 1 && d.isEmpty && !d.isDebtPayment),
                    ),
                ],
                activeId: state.activeId,
                onSelect: (id) => context.read<CheckoutBloc>().add(TabSelected(id)),
                onNew: () => context.read<CheckoutBloc>().add(const NewTabRequested()),
                onNewDebt: () => context.read<CheckoutBloc>().add(const NewDebtTabRequested()),
                newDebtLabel: l10n.payDebtTab,
                closeLabel: l10n.closeTab,
                onClose: (id) => confirmCloseTab(context, state.drafts.firstWhere((d) => d.id == id)),
                onShowAll: () async {
                  final bloc = context.read<CheckoutBloc>();
                  final id = await showOpenTabs(context, state.drafts, state.activeId);
                  if (id != null) bloc.add(TabSelected(id));
                },
              );
              return LayoutBuilder(
                builder: (context, constraints) {
                  final window = MediaQuery.sizeOf(context);
                  final wide = checkoutBeside(window);
                  // Short phones at large text: the tab strip scrolls with the products so the
                  // list keeps room. The header stays pinned because it holds the cart button.
                  final roomy = wide || constraints.maxHeight >= 600 * MediaQuery.textScalerOf(context).scale(1);
                  final header = roomy ? null : Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: strip);
                  final products = state.active?.isDebtPayment ?? false
                      ? DebtPane(header: header)
                      : ProductPane(onScan: () => _scan(context), header: header);
                  final main = Column(
                    children: [
                      // Short windows (phone landscape) drop the big title to give the list room.
                      _Header(showTitle: roomy && !wide),
                      if (roomy) ...[strip, const SizedBox(height: Space.sm)],
                      Expanded(key: const ValueKey('products'), child: products),
                      if (!wide) const _CartBar(),
                      // The shell floats the nav pill over this column and reports its height as bottom padding.
                      if (wide) SizedBox(height: MediaQuery.paddingOf(context).bottom),
                    ],
                  );
                  if (!wide) return ScrollsWhenShort(child: main);
                  // Tablets: the order runs full height beside the catalog, like a POS counter screen.
                  return Row(
                    children: [
                      Expanded(child: main),
                      // The panel stands apart from the catalog: a firmer edge than a card hairline plus a soft shadow.
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35))),
                          boxShadow: const [BoxShadow(color: Color(0x12000000), offset: Offset(-6, 0), blurRadius: 16)],
                        ),
                        child: SizedBox(width: checkoutPanelWidth(window.width), child: const CartPanel()),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Store and cashier in small print, one line, above the page title.
class _Header extends StatelessWidget {
  const _Header({required this.showTitle});
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final store = getIt<GetReceiptSettings>()().storeName;
    final cashier = getIt<GetCurrentSession>()()?.username;
    final muted = theme.textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: Space.sm,
            children: [
              Icon(Iconsax.shop_copy, size: 16, color: muted?.color),
              // One span so a narrow window cuts the line short instead of starting a row with "·".
              Expanded(
                child: Text(
                  [store.isEmpty ? l10n.storeNameMissing : store, if (cashier != null) l10n.cashierLine(cashier)].join('  ·  '),
                  style: muted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (showTitle) ...[
            const SizedBox(height: Space.xs),
            Text(l10n.checkoutTitle, style: theme.textTheme.headlineSmall),
          ],
        ],
      ),
    );
  }
}

/// Phones and portrait tablets: the active tab's count and total pinned in thumb reach,
/// opening the cart sheet. Hidden while the cart is empty.
class _CartBar extends StatelessWidget {
  const _CartBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final debtOnly = context.select<CheckoutBloc, bool>((b) => b.state.active?.isDebtPayment ?? false);
    final summary = context.select<CheckoutBloc, (double, int)?>((b) {
      final draft = b.state.active;
      return draft == null || draft.isEmpty ? null : (draft.itemCount, draft.total());
    });
    final debtCustomer = context.select<CheckoutBloc, String?>((b) {
      final draft = b.state.active;
      return draft != null && draft.isDebtPayment ? draft.customerName : null;
    });
    if (debtOnly) return debtCustomer == null ? const SizedBox.shrink() : _DebtBar(customer: debtCustomer, onOpen: () => _openCart(context));
    if (summary == null) return const SizedBox.shrink();
    final (count, total) = summary;
    final figures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.itemsCount(qty(context, count)), style: theme.textTheme.bodySmall),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(rupiah(context, total), style: theme.textTheme.titleLarge?.tabular),
        ),
      ],
    );
    // Large text: the button gets its own full-width line instead of crushing the total.
    final stacked = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final open = AppButton(
      label: l10n.viewCart,
      icon: Iconsax.shopping_cart_copy,
      large: true,
      expand: stacked,
      onPressed: () => _openCart(context),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
        child: stacked
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: Space.sm, children: [figures, open])
            : Row(spacing: Space.md, children: [Expanded(child: figures), open]),
      ),
    );
  }

  void _openCart(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ShellColors.of(context).canvas,
    builder: (_) => BlocProvider.value(
      value: context.read<CheckoutBloc>(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.94,
        maxChildSize: 0.94,
        builder: (_, controller) => CartPanel(scrollController: controller),
      ),
    ),
  );
}

/// The phone counterpart of the cart bar for a debt tab: who is being paid, and the way into the payment.
class _DebtBar extends StatelessWidget {
  const _DebtBar({required this.customer, required this.onOpen});
  final String customer;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stacked = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final name = Text(customer, style: theme.textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis);
    final open = AppButton(label: l10n.payDebtTab, icon: Iconsax.wallet_check_copy, large: true, expand: stacked, onPressed: onOpen);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
        // Large text: the button gets its own full-width line, like the sale cart bar.
        child: stacked
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: Space.sm, children: [name, open])
            : Row(spacing: Space.md, children: [Expanded(child: name), open]),
      ),
    );
  }
}
