import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/catalog/catalog_cubits.dart';
import '../../../../common/failure_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/products_cubit.dart';

/// Online edit. Staff see name, SKU, barcode, unit, prices, and existing
/// categories; purchase price, type, stock, and new categories are superadmin only.
class ProductEditPage extends StatelessWidget {
  const ProductEditPage({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductEditCubit>()..load(productId)),
        BlocProvider(create: (_) => getIt<ProductsCubit>()..start()),
      ],
      child: BlocConsumer<ProductEditCubit, ProductEditState>(
        listenWhen: (a, b) => b.saved && !a.saved,
        listener: (context, _) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.productSaved)));
          context.pop();
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l10n.editProduct)),
          body: state.product == null
              ? (state.loading ? const LoadingView() : ErrorState(message: failureText(context, state.failure!)))
              : _Form(product: state.product!, state: state),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({required this.product, required this.state});
  final Product product;
  final ProductEditState state;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.product.name);
  late final _sku = TextEditingController(text: widget.product.sku);
  late final _barcode = TextEditingController(text: widget.product.barcode ?? '');
  late final _price = TextEditingController(text: '${widget.product.sellingPrice}');
  late final _debtPrice = TextEditingController(text: '${widget.product.sellingPriceDebt}');
  late final _purchase = TextEditingController(text: '${widget.product.purchasePrice}');
  final _stockDelta = TextEditingController();
  final _newCategory = TextEditingController();
  late ProductUnit _unit = widget.product.unit;
  late ProductType _type = widget.product.type;
  late String _category = widget.product.categoryName;

  @override
  void dispose() {
    for (final c in [_name, _sku, _barcode, _price, _debtPrice, _purchase, _stockDelta, _newCategory]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save(bool isSuper) {
    if (!_form.currentState!.validate()) return;
    final p = widget.product;
    final barcode = _barcode.text.trim();
    final category = isSuper && _newCategory.text.trim().isNotEmpty ? _newCategory.text.trim() : _category;
    context.read<ProductEditCubit>().save(
      ProductPatch(
        name: _name.text.trim() == p.name ? null : _name.text.trim(),
        sku: _sku.text.trim() == p.sku ? null : _sku.text.trim(),
        barcode: barcode == (p.barcode ?? '') ? null : barcode,
        unit: _unit == p.unit ? null : _unit,
        sellingPrice: int.parse(_price.text) == p.sellingPrice ? null : int.parse(_price.text),
        sellingPriceDebt: int.parse(_debtPrice.text) == p.sellingPriceDebt ? null : int.parse(_debtPrice.text),
        category: category == p.categoryName ? null : category,
        purchasePrice: isSuper && int.parse(_purchase.text) != p.purchasePrice ? int.parse(_purchase.text) : null,
        type: isSuper && _type != p.type ? _type : null,
      ),
      stockDelta: isSuper ? double.tryParse(_stockDelta.text.replaceAll(',', '.')) ?? 0 : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isSuper = getIt<GetCurrentSession>()()?.role.isSuper ?? false;
    final categories = context.watch<ProductsCubit>().state.categories;
    final digits = [FilteringTextInputFormatter.digitsOnly];
    String? positive(String? v) => validationText(context, Validators.positiveInt(v));

    return SingleChildScrollView(
      child: ConstrainedBody(
        padding: const EdgeInsets.all(Space.lg),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: l10n.productName,
                controller: _name,
                validator: (v) => validationText(context, Validators.required(v)),
              ),
              const SizedBox(height: Space.lg),
              AppTextField(
                label: l10n.sku,
                controller: _sku,
                validator: (v) => validationText(context, Validators.sku(v)),
              ),
              const SizedBox(height: Space.lg),
              AppTextField(
                label: l10n.barcode,
                controller: _barcode,
                validator: (v) => validationText(context, Validators.barcode(v)),
              ),
              const SizedBox(height: Space.lg),
              DropdownButtonFormField<ProductUnit>(
                isExpanded: true,
                initialValue: _unit,
                decoration: InputDecoration(labelText: l10n.unit),
                items: [for (final u in ProductUnit.values) DropdownMenuItem(value: u, child: Text(u.name))],
                onChanged: (u) => setState(() => _unit = u ?? _unit),
              ),
              const SizedBox(height: Space.lg),
              AppTextField(
                label: l10n.sellingPrice,
                controller: _price,
                keyboardType: TextInputType.number,
                inputFormatters: digits,
                validator: positive,
              ),
              const SizedBox(height: Space.lg),
              AppTextField(
                label: l10n.debtPrice,
                controller: _debtPrice,
                keyboardType: TextInputType.number,
                inputFormatters: digits,
                validator: positive,
              ),
              const SizedBox(height: Space.lg),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: categories.any((c) => c.name == _category) ? _category : null,
                decoration: InputDecoration(labelText: l10n.category),
                items: [for (final c in categories) DropdownMenuItem(value: c.name, child: Text(c.name))],
                onChanged: (c) => setState(() => _category = c ?? _category),
              ),
              if (isSuper) ...[
                const SizedBox(height: Space.xl),
                Text(l10n.superOnly, style: theme.textTheme.titleSmall),
                const SizedBox(height: Space.md),
                AppTextField(label: l10n.newCategory, controller: _newCategory),
                const SizedBox(height: Space.lg),
                AppTextField(
                  label: l10n.purchasePrice,
                  controller: _purchase,
                  keyboardType: TextInputType.number,
                  inputFormatters: digits,
                  validator: positive,
                ),
                const SizedBox(height: Space.lg),
                SegmentedButton<ProductType>(
                  segments: [
                    ButtonSegment(value: ProductType.physical, label: Text(l10n.physical)),
                    ButtonSegment(value: ProductType.digital, label: Text(l10n.digital)),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                ),
                const SizedBox(height: Space.lg),
                AppTextField(
                  label: l10n.stockAdjust,
                  controller: _stockDelta,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                ),
              ],
              if (widget.state.failure != null) ...[
                const SizedBox(height: Space.lg),
                Text(failureText(context, widget.state.failure!), style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: Space.xl),
              Text(l10n.onlineOnly, style: theme.textTheme.bodySmall),
              const SizedBox(height: Space.sm),
              AppButton(
                label: l10n.save,
                large: true,
                expand: true,
                loading: widget.state.saving,
                onPressed: () => _save(isSuper),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
