import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../bloc/checkout_bloc.dart';

/// Search (also receives hardware-scanner input), category filter, and the
/// product list; tapping a card or its + adds one to the active tab.
class ProductPane extends StatefulWidget {
  const ProductPane({super.key, required this.onScan, this.header});

  final VoidCallback onScan;

  /// Scrolls away above the search when the screen is short.
  final Widget? header;

  @override
  State<ProductPane> createState() => _ProductPaneState();
}

class _ProductPaneState extends State<ProductPane> {
  final _search = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Enter from a USB/Bluetooth scanner: try it as a barcode first.
  void _submitted(String value) {
    final code = value.trim();
    if (code.isEmpty) return;
    context.read<CheckoutBloc>().add(BarcodeSubmitted(code));
    _search.clear();
    context.read<ProductsCubit>().search('');
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ProductsCubit>().state;

    // Search and filters scroll away with the list so large text never squeezes it.
    return CustomScrollView(
      slivers: [
        if (widget.header case final header?) SliverToBoxAdapter(child: header),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.sm),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _search,
                    focusNode: _focus,
                    hint: l10n.searchProducts,
                    onChanged: context.read<ProductsCubit>().search,
                    onSubmitted: _submitted,
                  ),
                ),
                const SizedBox(width: Space.sm),
                AppButton(label: l10n.scan, icon: Iconsax.scan_barcode_copy, variant: AppButtonVariant.outline, onPressed: widget.onScan),
              ],
            ),
          ),
        ),
        if (state.categories.isNotEmpty)
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
              child: Row(
                children: [
                  _CategoryChip(
                    label: l10n.allCategories,
                    selected: state.categoryId == null,
                    onTap: () => context.read<ProductsCubit>().filter(null),
                  ),
                  for (final c in state.categories)
                    _CategoryChip(
                      label: c.name,
                      selected: state.categoryId == c.id,
                      onTap: () => context.read<ProductsCubit>().filter(c.id),
                    ),
                ],
              ),
            ),
          ),
        ..._list(context, state, l10n),
      ],
    );
  }

  List<Widget> _list(BuildContext context, ProductsState state, AppLocalizations l10n) {
    if (state.loading) return const [SliverFillRemaining(hasScrollBody: false, child: LoadingView())];
    if (state.products.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Iconsax.box_copy,
            message: state.query.isEmpty && state.categoryId == null
                ? l10n.noProducts
                : l10n.noProductsMatch(state.query),
          ),
        ),
      ];
    }
    return [
      SliverLayoutBuilder(
        builder: (context, constraints) {
          // Tablets get a grid of product cards; phones keep a list so more fits and large text stays readable.
          if (constraints.crossAxisExtent >= 560) {
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisSpacing: Space.md,
                  crossAxisSpacing: Space.md,
                  mainAxisExtent: _ProductTile.extent(context),
                ),
                itemCount: state.products.length,
                itemBuilder: (context, i) =>
                    _ProductTile(key: ValueKey(state.products[i].id), product: state.products[i]),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xl),
            sliver: SliverList.separated(
              itemCount: state.products.length,
              separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
              itemBuilder: (context, i) => _ProductRow(key: ValueKey(state.products[i].id), product: state.products[i]),
            ),
          );
        },
      ),
    ];
  }
}

/// Quantity of [productId] already in the active tab, for the card badge.
double _inCart(BuildContext context, String productId) => context.select<CheckoutBloc, double>(
  (b) => b.state.active?.items.where((i) => i.productId == productId).fold<double>(0, (a, i) => a + i.qty) ?? 0,
);

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: Space.sm),
    child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
  );
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inCart = _inCart(context, product.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.md, Space.md, Space.sm, Space.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InitialAvatar(name: product.name, imageUrl: product.image, size: 48, colorKey: product.categoryId),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: Space.sm),
                      child: Text(product.name, style: theme.textTheme.titleSmall),
                    ),
                    const SizedBox(height: 2),
                    _StockLine(product: product, inCart: inCart),
                    // Price and the add button share the bottom line, as in the receipt.
                    Row(
                      children: [
                        Expanded(
                          child: Text(rupiah(context, product.sellingPrice), style: theme.textTheme.titleMedium?.tabular),
                        ),
                        _AddButton(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({super.key, required this.product});
  final Product product;

  /// Tile height that still fits two name lines at the current text scale (200 at 100%).
  static double extent(BuildContext context) => 100 + 100 * MediaQuery.textScalerOf(context).scale(16) / 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inCart = _inCart(context, product.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.md, Space.md, Space.sm, Space.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InitialAvatar(name: product.name, imageUrl: product.image, size: 48, colorKey: product.categoryId),
                  const Spacer(),
                  if (inCart > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: Space.xs),
                      child: _CartCount(qty: inCart),
                    ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text(product.name, style: theme.textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              // One line like the price: a wrapped stock line pushes the price row out of the fixed tile.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: _StockLine(product: product, inCart: 0),
              ),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(rupiah(context, product.sellingPrice), style: theme.textTheme.titleMedium?.tabular),
                    ),
                  ),
                  _AddButton(product: product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockLine extends StatelessWidget {
  const _StockLine({required this.product, required this.inCart});
  final Product product;
  final double inCart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = StatusColors.of(context);
    final empty = !product.isDigital && product.stock <= 0;
    final muted = theme.textTheme.bodySmall;
    return Text.rich(
      TextSpan(
        style: muted,
        children: [
          TextSpan(
            text: product.isDigital ? l10n.digital : (empty ? l10n.outOfStock : l10n.stock(qty(context, product.stock))),
            style: empty ? TextStyle(color: status.warning, fontWeight: FontWeight.w600) : null,
          ),
          if (inCart > 0) ...[
            const TextSpan(text: '  ·  '),
            TextSpan(
              text: l10n.inCart(qty(context, inCart)),
              style: TextStyle(color: status.success, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _CartCount extends StatelessWidget {
  const _CartCount({required this.qty});
  final double qty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: 2),
      decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(Radii.full)),
      child: Text(
        formatQty(qty),
        style: Theme.of(context).textTheme.labelMedium?.tabular.copyWith(color: scheme.onPrimary),
      ),
    );
  }
}

/// Small mint square; the whole card is also tappable, so the glyph never has to
/// carry the action alone.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => IconButton.filled(
    tooltip: AppLocalizations.of(context).addItem(product.name),
    style: IconButton.styleFrom(
      minimumSize: const Size.square(36),
      fixedSize: const Size.square(36),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.small + 4)),
    ),
    onPressed: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
    icon: const Icon(Icons.add_rounded, size: 20),
  );
}
