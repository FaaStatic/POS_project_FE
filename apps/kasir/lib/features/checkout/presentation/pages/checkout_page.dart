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

  static const _sideBySide = 720.0;

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
              final products = ProductPane(onScan: () => _scan(context));

              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= _sideBySide) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const _Header(),
                              strip,
                              const SizedBox(height: Space.sm),
                              Expanded(child: products),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, Space.lg, Space.lg, Space.lg),
                          child: SizedBox(
                            width: constraints.maxWidth >= 1000 ? 420 : 360,
                            child: const Card(clipBehavior: Clip.antiAlias, child: CartPanel()),
                          ),
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Column(
                        children: [
                          const _Header(),
                          strip,
                          const SizedBox(height: Space.sm),
                          Expanded(child: products),
                        ],
                      ),
                      const Positioned(left: 0, right: 0, bottom: 0, child: _CartBar()),
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

/// Store and cashier in small print above the page title.
class _Header extends StatelessWidget {
  const _Header();

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
          Wrap(
            spacing: Space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Iconsax.shop, size: 16, color: muted?.color),
              Text(store.isEmpty ? l10n.storeNameMissing : store, style: muted),
              if (cashier != null) Text('·  ${l10n.cashierLine(cashier)}', style: muted),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(l10n.checkoutTitle, style: theme.textTheme.headlineSmall),
        ],
      ),
    );
  }
}

/// Narrow layout: summary of the active tab with a button that opens the cart sheet.
class _CartBar extends StatelessWidget {
  const _CartBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final draft = context.select<CheckoutBloc, Draft?>((b) => b.state.active);
    if (draft == null) return const SizedBox.shrink();
    final status = switch (draft.status) {
      DraftStatus.awaitingPayment => draft.charge?.method == ChargeMethod.va ? l10n.waitingVa : l10n.waitingQris,
      DraftStatus.paid => l10n.paid,
      DraftStatus.open => null,
    };
    final empty = draft.isEmpty && status == null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openCart(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.md, Space.md),
            // Wrap drops the button below the summary when large text needs the room.
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.md,
              runSpacing: Space.sm,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(UiLocalizations.of(context).tabLabel(draft.number), style: theme.textTheme.bodySmall),
                    Text(
                      status ??
                          (empty
                              ? l10n.cartEmptyShort
                              : l10n.cartSummary(qty(context, draft.itemCount), rupiah(context, draft.total()))),
                      style: theme.textTheme.titleMedium?.tabular,
                    ),
                  ],
                ),
                AppButton(
                  label: l10n.viewCart,
                  icon: Iconsax.shopping_cart,
                  large: true,
                  onPressed: () => _openCart(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCart(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
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
