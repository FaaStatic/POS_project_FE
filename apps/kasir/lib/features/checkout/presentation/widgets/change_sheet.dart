import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';

/// One part of the change: money, or candy / another physical product taken from stock.
/// [remaining] is what is still to be handed back and prefills the cash amount.
Future<ChangeLine?> showChangeLineSheet(BuildContext context, {required int remaining}) =>
    showModalBottomSheet<ChangeLine>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ProductsCubit>()..start(),
        child: _ChangeLineSheet(remaining: remaining),
      ),
    );

class _ChangeLineSheet extends StatefulWidget {
  const _ChangeLineSheet({required this.remaining});
  final int remaining;

  @override
  State<_ChangeLineSheet> createState() => _ChangeLineSheetState();
}

class _ChangeLineSheetState extends State<_ChangeLineSheet> {
  late final _amount = TextEditingController(text: widget.remaining > 0 ? '${widget.remaining}' : '');
  final _qty = TextEditingController(text: '1');
  var _kind = ChangeKind.cash;
  Product? _product;

  @override
  void dispose() {
    _amount.dispose();
    _qty.dispose();
    super.dispose();
  }

  double get _qtyValue => double.tryParse(_qty.text.replaceAll(',', '.')) ?? 0;

  ChangeLine? get _line {
    if (_kind == ChangeKind.cash) {
      final amount = int.tryParse(_amount.text) ?? 0;
      return amount > 0 ? ChangeLine.cash(amount) : null;
    }
    final p = _product;
    if (p == null || _qtyValue <= 0 || _qtyValue > p.stock) return null;
    final line = ChangeLine.goods(
      kind: _kind,
      productId: p.id,
      productName: p.name,
      qty: _qtyValue,
      unitPrice: p.sellingPrice,
      wholeOnly: p.unit == ProductUnit.pcs,
    );
    return line.amount > 0 ? line : null;
  }

  void _select(Product p) => setState(() {
        _product = p;
        _qty.text = '1';
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final goods = _kind != ChangeKind.cash;
    final line = _line;
    final products = [
      for (final p in context.watch<ProductsCubit>().state.products)
        if (!p.isDigital && p.stock > 0) p,
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.changeSheetTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Space.lg),
            SegmentedButton<ChangeKind>(
              segments: [
                ButtonSegment(value: ChangeKind.cash, label: Text(l10n.changeCash)),
                ButtonSegment(value: ChangeKind.candy, label: Text(l10n.changeCandy)),
                ButtonSegment(value: ChangeKind.product, label: Text(l10n.changeProduct)),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.single),
            ),
            const SizedBox(height: Space.lg),
            if (!goods)
              AppTextField(
                label: l10n.changeAmount,
                controller: _amount,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
              )
            else ...[
              SearchField(hint: l10n.changePickProduct, onChanged: context.read<ProductsCubit>().search),
              const SizedBox(height: Space.sm),
              if (products.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Text(l10n.changeNoProducts, style: theme.textTheme.bodyMedium),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, i) {
                      final p = products[i];
                      return ListTile(
                        key: ValueKey(p.id),
                        selected: p.id == _product?.id,
                        title: Text(p.name),
                        subtitle: Text('${rupiah(context, p.sellingPrice)} · ${l10n.stock(qty(context, p.stock))}'),
                        onTap: () => _select(p),
                      );
                    },
                  ),
                ),
              if (_product != null) ...[
                const SizedBox(height: Space.md),
                AppTextField(
                  label: l10n.changeQty,
                  controller: _qty,
                  keyboardType: TextInputType.numberWithOptions(decimal: _product!.unit != ProductUnit.pcs),
                  inputFormatters: qtyInputFormatters(fraction: _product!.unit != ProductUnit.pcs),
                  onChanged: (_) => setState(() {}),
                ),
                if (_qtyValue > _product!.stock)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.xs),
                    child: Text(
                      l10n.stock(qty(context, _product!.stock)),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                    ),
                  )
                else if (line != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.xs),
                    child: Text(l10n.changeValue(rupiah(context, line.amount)), style: theme.textTheme.bodySmall),
                  ),
              ],
            ],
            const SizedBox(height: Space.lg),
            AppButton(
              label: l10n.add,
              large: true,
              expand: true,
              onPressed: line == null ? null : () => Navigator.pop(context, line),
            ),
          ],
        ),
      ),
    );
  }
}
