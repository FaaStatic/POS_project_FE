import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/feedback.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/products_cubit.dart';
import 'product_form.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, this.openAdd = false});

  /// Set by the dashboard quick action.
  final bool openAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ProductsCubit>();
        cubit.load().then((_) {
          if (openAdd && context.mounted) openProductForm(context, cubit);
        });
        return cubit;
      },
      child: Builder(builder: (context) {
        final cubit = context.read<ProductsCubit>();
        final state = context.watch<ProductsCubit>().state;
        final theme = Theme.of(context);
        return CmsPage(
          title: l10n.productsTitle,
          actions: [
            OutlinedButton.icon(onPressed: () => context.push('/products/bulk'), icon: const Icon(Iconsax.document_upload), label: Text(l10n.bulkAdd)),
            FilledButton.icon(onPressed: () => openProductForm(context, cubit), icon: const Icon(Iconsax.add), label: Text(l10n.addProduct)),
          ],
          body: Column(
            children: [
              FilterBar(children: [
                SizedBox(width: 320, child: SearchField(hint: l10n.search, onChanged: cubit.search)),
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<String?>(
                    isExpanded: true,
                    initialValue: cubit.query.categoryId,
                    decoration: InputDecoration(labelText: l10n.category),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.allCategories)),
                      for (final c in cubit.categories) DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: cubit.filter,
                  ),
                ),
              ]),
              Expanded(
                child: PagedBody<Product>(
                  state: state,
                  emptyMessage: cubit.query.search?.isNotEmpty == true || cubit.query.categoryId != null ? l10n.productsNoMatch : l10n.productsEmpty,
                  emptyAction: l10n.addProduct,
                  onEmptyAction: () => openProductForm(context, cubit),
                  onRetry: cubit.load,
                  builder: (items) => ResponsiveTable<Product>(
                    rows: items,
                    rowKey: (p) => p.id,
                    onTap: (p) => openProductForm(context, cubit, existing: p),
                    hasMore: state.hasNext,
                    loadingMore: state.loadingMore,
                    onLoadMore: cubit.loadMore,
                    columns: [
                      TableColumnSpec(label: l10n.productName, flex: 3, cell: (_, p) => Text(p.name)),
                      TableColumnSpec(label: l10n.sku, cell: (_, p) => Text(p.sku)),
                      TableColumnSpec(label: l10n.barcode, secondary: true, cell: (_, p) => Text(p.barcode ?? '-')),
                      TableColumnSpec(label: l10n.category, secondary: true, cell: (_, p) => Text(p.categoryName.isEmpty ? '-' : p.categoryName)),
                      TableColumnSpec(label: l10n.sellingPrice, numeric: true, cell: (c, p) => Text(money(c, p.sellingPrice), style: theme.textTheme.bodyMedium?.tabular)),
                      TableColumnSpec(
                        label: l10n.stock,
                        numeric: true,
                        cell: (c, p) => Text(
                          p.isDigital ? '-' : '${formatQty(p.stock, locale: Localizations.localeOf(c).languageCode)} ${p.unit.name}',
                          style: theme.textTheme.bodyMedium?.tabular,
                        ),
                      ),
                    ],
                    actions: (context, p) => ActionsMenu(actions: [
                      RowAction(l10n.edit, () => openProductForm(context, cubit, existing: p)),
                      if (!p.isDigital) RowAction(l10n.adjustStock, () => _stock(context, cubit, p)),
                      RowAction(l10n.delete, () => _delete(context, cubit, p), destructive: true),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _stock(BuildContext context, ProductsCubit cubit, Product p) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showFormSurface<bool>(
      context,
      title: '${l10n.adjustStock} · ${p.name}',
      child: StockForm(product: p, onSubmit: (d) => cubit.adjustStock(p, d)),
    );
    if (ok == true && context.mounted) toast(context, l10n.stockUpdated);
  }

  Future<void> _delete(BuildContext context, ProductsCubit cubit, Product p) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showConfirmDialog(context, title: l10n.deleteProductTitle(p.name), confirmLabel: l10n.delete, destructive: true);
    if (!ok || !context.mounted) return;
    final result = await cubit.delete(p);
    if (context.mounted) showResult(context, result, l10n.productDeleted);
  }
}

Future<void> openProductForm(BuildContext context, ProductsCubit cubit, {Product? existing}) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showFormSurface<bool>(
    context,
    title: existing == null ? l10n.addProduct : l10n.editProduct,
    child: ProductForm(
      existing: existing,
      categories: cubit.categories,
      onCreate: cubit.create,
      onUpdate: (patch) => cubit.update(existing!, patch),
    ),
  );
  if (ok == true && context.mounted) toast(context, l10n.productSaved);
}
