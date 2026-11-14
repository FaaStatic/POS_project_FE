import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../common/load_more_on_scroll.dart';
import '../../../../common/pull_refresh.dart';
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
    final products = context.read<ProductsCubit>();

    // Search and category pills stay put; only the products scroll under them. Each part listens only
    // to the state it draws, so a stock change rebuilds the rows and not the search field, and a new
    // category list leaves the rows alone. Keyed: the tab header appears above the search when the
    // screen is short, and an unkeyed child would be matched by position, rebuilding the field and
    // closing the keyboard.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.header case final header?)
          KeyedSubtree(key: const ValueKey('tabs'), child: header),
        KeyedSubtree(
          key: const ValueKey('search'),
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.md,
                    Space.lg,
                    Space.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          controller: _search,
                          focusNode: _focus,
                          hint: l10n.searchProducts,
                          onChanged: products.search,
                          onSubmitted: _submitted,
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      // One filled square next to the search field, as on a phone POS; the tooltip and semantics carry the label.
                      IconButton.filled(
                        tooltip: l10n.scan,
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(TapSize.min),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.of(context).controlRadius)),
                        ),
                        onPressed: widget.onScan,
                        icon: const Icon(Iconsax.scan_barcode_copy),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ProductsCubit, ProductsState>(
                  buildWhen: (a, b) =>
                      a.categories != b.categories ||
                      a.categoryId != b.categoryId,
                  builder: (context, state) => state.categories.isEmpty
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(
                            Space.lg,
                            0,
                            Space.lg,
                            Space.sm,
                          ),
                          child: Row(
                            children: [
                              _CategoryChip(
                                label: l10n.allCategories,
                                selected: state.categoryId == null,
                                onTap: () => products.filter(null),
                              ),
                              for (final c in state.categories)
                                _CategoryChip(
                                  label: c.name,
                                  selected: state.categoryId == c.id,
                                  onTap: () => products.filter(c.id),
                                ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          key: const ValueKey('list'),
          child: LoadMoreOnScroll(
            onEnd: products.loadMore,
            child: PullRefresh(
              child: CustomScrollView(
                physics: PullRefresh.physics,
                slivers: [
                  BlocBuilder<ProductsCubit, ProductsState>(
                    buildWhen: (a, b) =>
                        a.loading != b.loading ||
                        !identical(a.products, b.products) ||
                        a.hasMore != b.hasMore ||
                        a.loadingMore != b.loadingMore ||
                        a.query != b.query ||
                        a.categoryId != b.categoryId,
                    builder: (context, state) => SliverMainAxisGroup(
                      slivers: _list(context, state, l10n),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _list(
    BuildContext context,
    ProductsState state,
    AppLocalizations l10n,
  ) {
    if (state.loading) {
      return const [SliverFillRemaining(hasScrollBody: false, child: LoadingView())];
    }
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
    final products = state.products;
    // Rows keep their element when the order changes (the best seller moves up after a sale)
    // instead of being rebuilt from scratch.
    final indexOf = {
      for (var i = 0; i < products.length; i++) products[i].id: i,
    };
    int? findIndex(Key key) =>
        key is ValueKey<String> ? indexOf[key.value] : null;
    return [
      SliverLayoutBuilder(
        builder: (context, constraints) {
          // Tablets get a grid of product cards; phones keep a list so more fits and large text stays readable.
          if (constraints.crossAxisExtent >= 560) {
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                Space.lg,
                Space.sm,
                Space.lg,
                Space.md,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisSpacing: Space.md,
                  crossAxisSpacing: Space.md,
                  mainAxisExtent: _ProductTile.extent(context),
                ),
                findChildIndexCallback: findIndex,
                addAutomaticKeepAlives: false,
                itemCount: products.length,
                itemBuilder: (context, i) => _ProductTile(
                  key: ValueKey(products[i].id),
                  product: products[i],
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.md,
            ),
            sliver: SliverList.separated(
              findItemIndexCallback: findIndex,
              addAutomaticKeepAlives: false,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
              itemBuilder: (context, i) => _ProductRow(
                key: ValueKey(products[i].id),
                product: products[i],
              ),
            ),
          );
        },
      ),
      // The next page is read as the end nears; the spinner only shows in that short gap.
      SliverToBoxAdapter(
        child: state.loadingMore
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: Space.lg),
                child: Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              )
            : const SizedBox(height: Space.xl),
      ),
    ];
  }
}

/// Quantity of [productId] already in the active tab, for the card badge.
double _inCart(BuildContext context, String productId) =>
    context.select<CheckoutBloc, double>(
      (b) =>
          b.state.active?.items
              .where((i) => i.productId == productId)
              .fold<double>(0, (a, i) => a + i.qty) ??
          0,
    );

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: Space.sm),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

/// A tappable surface for the product list. Material's Card and InkWell build about twenty elements per row
/// (animated style, shape paint, ink and focus plumbing); with a dozen rows entering the screen on every
/// flick that was most of the frame. This is one decorated box with a pressed color, which is all the
/// list needs.
class _PressCard extends StatefulWidget {
  const _PressCard({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_PressCard> createState() => _PressCardState();
}

class _PressCardState extends State<_PressCard> {
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _down ? scheme.surfaceContainerHigh : scheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.of(context).cardRadius),
        ),
        child: widget.child,
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inCart = _inCart(context, product.id);
    return _PressCard(
      onTap: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.md,
            Space.sm,
            Space.md,
          ),
          // Name over price and stock, add button at the end: about 76 high, so a phone shows twice the items.
          child: Row(
            spacing: Space.md,
            children: [
              InitialAvatar(
                name: product.name,
                imageUrl: product.image,
                size: 44,
                colorKey: product.categoryId,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: Space.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          rupiah(context, product.sellingPrice),
                          style: theme.textTheme.titleMedium?.tabular,
                        ),
                        _StockLine(product: product, inCart: inCart),
                      ],
                    ),
                  ],
                ),
              ),
              _AddButton(product: product),
            ],
          ),
        ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({super.key, required this.product});
  final Product product;

  /// Tile height that still fits two name lines at the current text scale (200 at 100%).
  static double extent(BuildContext context) =>
      100 + 100 * MediaQuery.textScalerOf(context).scale(16) / 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inCart = _inCart(context, product.id);
    return _PressCard(
      onTap: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.md,
            Space.sm,
            Space.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InitialAvatar(
                    name: product.name,
                    imageUrl: product.image,
                    size: 48,
                    colorKey: product.categoryId,
                  ),
                  const Spacer(),
                  if (inCart > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: Space.xs),
                      child: _CartCount(qty: inCart),
                    ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text(
                product.name,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Stock stays under the name; spare height of a one-line name goes above the price row.
              // One line like the price: a wrapped stock line pushes the price row out of the fixed tile.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: _StockLine(product: product, inCart: 0),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        rupiah(context, product.sellingPrice),
                        style: theme.textTheme.titleMedium?.tabular,
                      ),
                    ),
                  ),
                  _AddButton(product: product),
                ],
              ),
            ],
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
            text: product.isDigital
                ? l10n.digital
                : (empty
                      ? l10n.outOfStock
                      : l10n.stock(qty(context, product.stock))),
            style: empty
                ? TextStyle(color: status.warning, fontWeight: FontWeight.w600)
                : null,
          ),
          if (inCart > 0) ...[
            const TextSpan(text: '  ·  '),
            TextSpan(
              text: l10n.inCart(qty(context, inCart)),
              style: TextStyle(
                color: status.success,
                fontWeight: FontWeight.w600,
              ),
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
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(Radii.full),
      ),
      child: Text(
        formatQty(qty),
        style: Theme.of(context).textTheme.labelMedium?.tabular
            .copyWith(color: scheme.onPrimary),
      ),
    );
  }
}

/// Small blue square that shows the card is an "add" target. The whole card is the tap target, so this
/// is only drawn: a real IconButton per row (tooltip, ink, focus, style resolution) made scrolling the
/// list heavy. Screen readers still get a named button with its own tap action. A product with no stock
/// is drawn off; tapping its card still explains why it was not added.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = product.isDigital || product.stock > 0;
    return Semantics(
      button: true,
      enabled: enabled,
      label: AppLocalizations.of(context).addItem(product.name),
      onTap: enabled ? () => context.read<CheckoutBloc>().add(ProductAdded(product)) : null,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: enabled ? scheme.primary : scheme.onSurface.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Radii.small + 4),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20,
            color: enabled ? scheme.onPrimary : scheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
      ),
    );
  }
}
