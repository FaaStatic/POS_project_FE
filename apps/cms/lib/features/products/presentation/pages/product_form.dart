import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

import '../../../../common/failure_text.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';

/// Add or edit a product (superadmin: every field). The category field accepts
/// an existing name or a new one; the backend creates new categories itself.
class ProductForm extends StatefulWidget {
  const ProductForm({super.key, required this.categories, required this.onCreate, required this.onUpdate, this.existing});
  final Product? existing;
  final List<Category> categories;
  final Future<Result<Object?>> Function(NewProduct p) onCreate;
  final Future<Result<Object?>> Function(ProductPatch patch) onUpdate;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _form = GlobalKey<FormState>();
  late final Product? p = widget.existing;
  late final _name = TextEditingController(text: p?.name);
  late final _sku = TextEditingController(text: p?.sku);
  late final _barcode = TextEditingController(text: p?.barcode);
  late final _purchase = TextEditingController(text: p == null ? '' : '${p!.purchasePrice}');
  late final _price = TextEditingController(text: p == null ? '' : '${p!.sellingPrice}');
  late final _debtPrice = TextEditingController(text: p == null ? '' : '${p!.sellingPriceDebt}');
  final _stock = TextEditingController(text: '0');
  late final _category = TextEditingController(text: p?.categoryName);
  late final _image = TextEditingController(text: p?.image);
  final _categoryFocus = FocusNode();
  late ProductUnit _unit = p?.unit ?? ProductUnit.pcs;
  late ProductType _type = p?.type ?? ProductType.physical;
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    for (final c in [_name, _sku, _barcode, _purchase, _price, _debtPrice, _stock, _category, _image]) {
      c.dispose();
    }
    _categoryFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final p = this.p;
    final Result<Object?> result;
    if (p == null) {
      result = await widget.onCreate(NewProduct(
        sku: _sku.text.trim(),
        barcode: _barcode.text.trim(),
        name: _name.text.trim(),
        unit: _unit,
        type: _type,
        purchasePrice: int.parse(_purchase.text),
        sellingPrice: int.parse(_price.text),
        sellingPriceDebt: int.parse(_debtPrice.text),
        stock: double.parse(_stock.text.replaceAll(',', '.')),
        category: _category.text.trim(),
        image: _image.text.trim(),
      ));
    } else {
      T? changed<T>(T next, T current) => next == current ? null : next;
      result = await widget.onUpdate(ProductPatch(
        name: changed(_name.text.trim(), p.name),
        sku: changed(_sku.text.trim(), p.sku),
        barcode: changed(_barcode.text.trim(), p.barcode ?? ''),
        unit: changed(_unit, p.unit),
        type: changed(_type, p.type),
        purchasePrice: changed(int.parse(_purchase.text), p.purchasePrice),
        sellingPrice: changed(int.parse(_price.text), p.sellingPrice),
        sellingPriceDebt: changed(int.parse(_debtPrice.text), p.sellingPriceDebt),
        category: changed(_category.text.trim(), p.categoryName),
        image: changed(_image.text.trim(), p.image),
      ));
    }
    if (!mounted) return;
    if (result case Err(:final failure)) {
      setState(() {
        _saving = false;
        _failure = failure;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final digits = [FilteringTextInputFormatter.digitsOnly];
    String? positive(String? v) => validationText(context, Validators.positiveInt(v));
    Widget pair(Widget a, Widget b) => LayoutBuilder(
          builder: (context, c) => c.maxWidth < 440
              ? Column(children: [a, const SizedBox(height: Space.lg), b])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: a),
                  const SizedBox(width: Space.lg),
                  Expanded(child: b),
                ]),
        );

    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(label: l10n.productName, controller: _name, autofocus: true, validator: (v) => validationText(context, Validators.required(v))),
          const SizedBox(height: Space.lg),
          pair(
            AppTextField(label: l10n.sku, controller: _sku, validator: (v) => validationText(context, Validators.sku(v))),
            AppTextField(label: l10n.barcode, helper: l10n.barcodeHint, controller: _barcode, validator: (v) => validationText(context, Validators.barcode(v))),
          ),
          const SizedBox(height: Space.lg),
          pair(
            AppSelect<ProductUnit>(
              label: l10n.unit,
              value: _unit,
              choices: [for (final u in ProductUnit.values) Choice(u, u.name)],
              onChanged: (u) => setState(() => _unit = u),
            ),
            AppSelect<ProductType>(
              label: l10n.productType,
              value: _type,
              choices: [Choice(ProductType.physical, l10n.physical), Choice(ProductType.digital, l10n.digital)],
              onChanged: (t) => setState(() => _type = t),
            ),
          ),
          const SizedBox(height: Space.lg),
          AppTextField(label: l10n.purchasePrice, controller: _purchase, keyboardType: TextInputType.number, inputFormatters: digits, validator: positive),
          const SizedBox(height: Space.lg),
          pair(
            AppTextField(label: l10n.sellingPrice, controller: _price, keyboardType: TextInputType.number, inputFormatters: digits, validator: positive),
            AppTextField(label: l10n.debtPrice, controller: _debtPrice, keyboardType: TextInputType.number, inputFormatters: digits, validator: positive),
          ),
          if (p == null) ...[
            const SizedBox(height: Space.lg),
            AppTextField(
              label: l10n.stock,
              controller: _stock,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => validationText(context, Validators.nonNegativeNumber(v)),
            ),
          ],
          const SizedBox(height: Space.lg),
          Autocomplete<String>(
            textEditingController: _category,
            focusNode: _categoryFocus,
            optionsBuilder: (v) => widget.categories.map((c) => c.name).where((n) => n.toLowerCase().contains(v.text.toLowerCase())),
            fieldViewBuilder: (context, controller, focus, _) => AppTextField(
              label: l10n.category,
              helper: l10n.categoryNewHint,
              controller: controller,
              focusNode: focus,
              validator: (v) => validationText(context, Validators.categoryName(v)),
            ),
          ),
          const SizedBox(height: Space.lg),
          AppTextField(label: l10n.imageUrl, controller: _image, keyboardType: TextInputType.url),
          const SizedBox(height: Space.xl),
          FormActions(onSave: _save, saving: _saving, failure: _failure),
        ],
      ),
    );
  }
}

class StockForm extends StatefulWidget {
  const StockForm({super.key, required this.product, required this.onSubmit});
  final Product product;
  final Future<Result<void>> Function(double delta) onSubmit;

  @override
  State<StockForm> createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _delta = TextEditingController();
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _delta.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final delta = double.tryParse(_delta.text.replaceAll(',', '.')) ?? 0;
    setState(() => _saving = true);
    final result = await widget.onSubmit(delta);
    if (!mounted) return;
    if (result case Err(:final failure)) {
      setState(() {
        _saving = false;
        _failure = failure;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('${l10n.stock}: ${formatQty(widget.product.stock, locale: Localizations.localeOf(context).languageCode)} ${widget.product.unit.name}'),
        const SizedBox(height: Space.lg),
        AppTextField(
          label: l10n.stockDelta,
          controller: _delta,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.,]'))],
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: Space.xl),
        FormActions(onSave: _save, saving: _saving, failure: _failure),
      ],
    );
  }
}
