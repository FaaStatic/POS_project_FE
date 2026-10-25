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
/// product list with a labelled "Tambah" button per row.
class ProductPane extends StatefulWidget {
  const ProductPane({super.key, required this.onScan});

  final VoidCallback onScan;

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
                OutlinedButton.icon(
                  onPressed: widget.onScan,
                  icon: const Icon(Iconsax.scan_barcode),
                  label: Text(l10n.scan),
                ),
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
                  _CategoryChip(label: l10n.allCategories, selected: state.categoryId == null, onTap: () => context.read<ProductsCubit>().filter(null)),
                  for (final c in state.categories)
                    _CategoryChip(label: c.name, selected: state.categoryId == c.id, onTap: () => context.read<ProductsCubit>().filter(c.id)),
                ],
              ),
            ),
          ),
        const SliverToBoxAdapter(child: Divider()),
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
            icon: Iconsax.box,
            message: state.query.isEmpty && state.categoryId == null ? l10n.noProducts : l10n.noProductsMatch(state.query),
          ),
        ),
      ];
    }
    return [
      SliverList.separated(
        itemCount: state.products.length,
        separatorBuilder: (_, _) => const Divider(indent: Space.lg),
        itemBuilder: (context, i) => _ProductRow(key: ValueKey(state.products[i].id), product: state.products[i]),
      ),
    ];
  }
}

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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = StatusColors.of(context);
    final empty = !product.isDigital && product.stock <= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Wrap(
                  spacing: Space.md,
                  children: [
                    Text(rupiah(context, product.sellingPrice), style: theme.textTheme.bodyMedium?.tabular),
                    if (product.isDigital)
                      Text(l10n.digital, style: theme.textTheme.bodySmall)
                    else
                      Text(
                        empty ? l10n.outOfStock : l10n.stock(qty(context, product.stock)),
                        style: theme.textTheme.bodySmall?.copyWith(color: empty ? status.warning : null),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          FilledButton.tonalIcon(
            onPressed: () => context.read<CheckoutBloc>().add(ProductAdded(product)),
            icon: const Icon(Iconsax.add, size: 20),
            label: Text(l10n.add),
          ),
        ],
      ),
    );
  }
}
