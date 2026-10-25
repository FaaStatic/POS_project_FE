import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../bloc/assign_barcode_cubit.dart';

/// Unknown barcode → pick an existing product to attach it to (online).
Future<Product?> showAssignBarcode(BuildContext context, String code) => showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ProductsCubit>()..start()),
          BlocProvider(create: (_) => getIt<AssignBarcodeCubit>()),
        ],
        child: _AssignBarcode(code: code),
      ),
    );

class _AssignBarcode extends StatelessWidget {
  const _AssignBarcode({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = context.watch<ProductsCubit>().state;
    final assign = context.watch<AssignBarcodeCubit>().state;
    return BlocListener<AssignBarcodeCubit, AssignBarcodeState>(
      listenWhen: (a, b) => b.product != null && a.product == null,
      listener: (context, s) => Navigator.pop(context, s.product),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (context, controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
              child: Text(l10n.assignBarcodeTitle(code), style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: SearchField(hint: l10n.searchProducts, onChanged: context.read<ProductsCubit>().search),
            ),
            if (assign.failure != null)
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Text(failureText(context, assign.failure!), style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            if (assign.saving) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: products.products.length,
                itemBuilder: (context, i) {
                  final p = products.products[i];
                  return ListTile(
                    key: ValueKey(p.id),
                    title: Text(p.name),
                    subtitle: Text([p.sku, if (p.barcode != null) p.barcode!].join(' · ')),
                    trailing: Text(rupiah(context, p.sellingPrice)),
                    enabled: !assign.saving,
                    onTap: () => context.read<AssignBarcodeCubit>().assign(p, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
