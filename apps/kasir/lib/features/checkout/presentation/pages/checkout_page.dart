import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/cart_panel.dart';
import '../widgets/open_tabs_sheet.dart';
import '../widgets/product_list.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  /// Landscape tablets; portrait tablets keep the grid and open the cart as a sheet.
  static const _sideBySide = 900.0;

  Future<void> _scan(BuildContext context) async {
    final bloc = context.read<CheckoutBloc>();
    final code = await context.push<String>('/scan');
    if (code != null) bloc.add(BarcodeSubmitted(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..start(),
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
                      highlight: d.status != DraftStatus.open,
                      subtitle: switch (d.status) {
                        DraftStatus.awaitingPayment =>
                          d.charge?.method == ChargeMethod.va ? l10n.waitingVa : l10n.waitingQris,
                        DraftStatus.paid => l10n.paid,
                        DraftStatus.open => l10n.cartSummary(qty(context, d.itemCount), rupiah(context, d.total())),
                      },
                    ),
                ],
                activeId: state.activeId,
                onSelect: (id) => context.read<CheckoutBloc>().add(TabSelected(id)),
                onNew: () => context.read<CheckoutBloc>().add(const NewTabRequested()),
                onShowAll: () async {
                  final bloc = context.read<CheckoutBloc>();
                  final id = await showOpenTabs(context, state.drafts, state.activeId);
                  if (id != null) bloc.add(TabSelected(id));
                },
              );
              return LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= _sideBySide;
                  // Short phones at large text: the tab strip scrolls with the products so the
                  // list keeps room. The header stays pinned because it holds the cart button.
                  final roomy = wide || constraints.maxHeight >= 600 * MediaQuery.textScalerOf(context).scale(1);
                  final products = ProductPane(
                    onScan: () => _scan(context),
                    header: roomy ? null : Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: strip),
                  );
                  final main = Column(
                    children: [
                      _Header(showCart: !wide),
                      if (roomy) ...[strip, const SizedBox(height: Space.sm)],
                      Expanded(child: products),
                    ],
                  );
                  if (!wide) return main;
                  // Tablets: the order runs full height beside the catalog, like a POS counter screen.
                  return Row(
                    children: [
                      Expanded(child: main),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth >= 1100 ? 420 : 380,
                          child: const CartPanel(),
                        ),
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

/// Store and cashier in small print above the page title; phones add the cart button.
class _Header extends StatelessWidget {
  const _Header({required this.showCart});
  final bool showCart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final store = getIt<GetReceiptSettings>()().storeName;
    final cashier = getIt<GetCurrentSession>()()?.username;
    final muted = theme.textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.md, Space.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Space.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Iconsax.shop_copy, size: 16, color: muted?.color),
                    Text(store.isEmpty ? l10n.storeNameMissing : store, style: muted),
                    if (cashier != null) Text('·  ${l10n.cashierLine(cashier)}', style: muted),
                  ],
                ),
                const SizedBox(height: Space.xs),
                Text(l10n.checkoutTitle, style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
          if (showCart) const _CartButton(),
        ],
      ),
    );
  }
}

/// Phones: cart icon with the active tab's item count; opens the cart sheet.
class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = context.select<CheckoutBloc, double>((b) => b.state.active?.itemCount ?? 0);
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: l10n.viewCart,
      onPressed: () => _openCart(context),
      style: IconButton.styleFrom(
        minimumSize: const Size.square(52),
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.medium)),
      ),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(formatQty(count)),
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
        child: const Icon(Iconsax.shopping_cart_copy),
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
