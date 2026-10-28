import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/kasir_page.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..start(),
      child: Builder(
        builder: (context) {
          final state = context.watch<ProductsCubit>().state;
          final theme = Theme.of(context);
          return KasirPage(
            title: l10n.productsTitle,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: SearchField(hint: l10n.searchProducts, onChanged: context.read<ProductsCubit>().search),
                ),
                Expanded(
                  child: state.loading
                      ? const LoadingView()
                      : state.products.isEmpty
                      ? EmptyState(icon: Iconsax.box_copy, message: l10n.noProducts)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
                          itemCount: state.products.length,
                          separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
                          itemBuilder: (context, i) {
                            final p = state.products[i];
                            return Card(
                              key: ValueKey(p.id),
                              clipBehavior: Clip.antiAlias,
                              // Price under the details, not trailing: at large text a trailing price leaves no room.
                              child: ListTile(
                                leading: InitialAvatar(name: p.name, imageUrl: p.image, size: 40, colorKey: p.categoryId),
                                title: Text(p.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        p.sku,
                                        if (p.barcode != null) p.barcode!,
                                        if (!p.isDigital) l10n.stock(qty(context, p.stock)),
                                      ].join(' · '),
                                    ),
                                    Text(rupiah(context, p.sellingPrice), style: theme.textTheme.titleSmall?.tabular),
                                  ],
                                ),
                                onTap: () => context.push('/settings/products/${p.id}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
