import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../common/catalog/catalog_cubits.dart';
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
                        DraftStatus.awaitingPayment => d.charge?.method == ChargeMethod.va ? l10n.waitingVa : l10n.waitingQris,
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

              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth >= _sideBySide) {
                  return Row(
                    children: [
                      Expanded(child: ProductPane(onScan: () => _scan(context))),
                      const VerticalDivider(width: 1),
                      SizedBox(
                        width: constraints.maxWidth >= 1000 ? 420 : 360,
                        child: Column(children: [strip, const Expanded(child: CartPanel())]),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    strip,
                    Expanded(child: ProductPane(onScan: () => _scan(context))),
                    const _CartBar(),
                  ],
                );
              });
            },
          ),
        ),
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
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
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
                  Text(UiLocalizations.of(context).tabLabel(draft.number), style: theme.textTheme.labelLarge),
                  Text(
                    status ?? l10n.cartSummary(qty(context, draft.itemCount), rupiah(context, draft.total())),
                    style: theme.textTheme.titleMedium?.tabular,
                  ),
                ],
              ),
              AppButton(
                label: l10n.viewCart,
                large: true,
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<CheckoutBloc>(),
                    child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.92,
                      maxChildSize: 0.92,
                      builder: (_, controller) => CartPanel(scrollController: controller),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
