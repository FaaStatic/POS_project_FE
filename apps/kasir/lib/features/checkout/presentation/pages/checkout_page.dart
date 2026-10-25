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
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          buildWhen: (a, b) => a.drafts != b.drafts || a.activeId != b.activeId || a.loading != b.loading,
          builder: (context, state) {
            if (state.loading) return const LoadingView();
            final strip = TransactionTabStrip(
              onBrand: true,
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

            // The green header reaches under the status bar.
            final header = ColoredBox(
              color: ShellColors.of(context).background,
              child: SafeArea(bottom: false, child: strip),
            );
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= _sideBySide) {
                  return Row(
                    children: [
                      Expanded(
                        child: SafeArea(bottom: false, child: ProductPane(onScan: () => _scan(context))),
                      ),
                      SizedBox(
                        width: constraints.maxWidth >= 1000 ? 420 : 360,
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 3,
                          shadowColor: const Color(0x1A0F3D2E),
                          child: Column(
                            children: [
                              header,
                              const Expanded(child: CartPanel()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Stack(
                  children: [
                    Column(
                      children: [
                        header,
                        Expanded(child: ProductPane(onScan: () => _scan(context))),
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
    final shell = ShellColors.of(context);
    final empty = draft.isEmpty && status == null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
        child: Material(
          color: shell.background,
          elevation: 6,
          shadowColor: const Color(0x330F3D2E),
          borderRadius: BorderRadius.circular(Radii.medium + 4),
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
                      Text(
                        UiLocalizations.of(context).tabLabel(draft.number),
                        style: theme.textTheme.labelLarge?.copyWith(color: shell.muted),
                      ),
                      Text(
                        status ??
                            (empty
                                ? l10n.cartEmptyShort
                                : l10n.cartSummary(qty(context, draft.itemCount), rupiah(context, draft.total()))),
                        style: theme.textTheme.titleMedium?.tabular.copyWith(color: shell.foreground),
                      ),
                    ],
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: shell.indicator,
                      foregroundColor: shell.onIndicator,
                      minimumSize: const Size(TapSize.min, TapSize.primary),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => _openCart(context),
                    child: Text(l10n.viewCart),
                  ),
                ],
              ),
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
        initialChildSize: 0.92,
        maxChildSize: 0.92,
        builder: (_, controller) => CartPanel(scrollController: controller),
      ),
    ),
  );
}
