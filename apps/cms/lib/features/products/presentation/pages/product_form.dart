import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/auto_sku.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/form_layout.dart';
import '../../../../common/product_image_field.dart';
import '../../../../common/sku_book.dart';
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
  /// Raw base64 of the chosen picture, a legacy URL kept as stored, or empty for none.
  late String _image = p?.image ?? '';
  late ProductUnit _unit = p?.unit ?? ProductUnit.pcs;
  late ProductType _type = p?.type ?? ProductType.physical;
  bool _saving = false;
  Failure? _failure;

  // A new product's SKU follows its category, type, and name until the user types one. An existing
  // product keeps the SKU it has: it is the key a bulk import matches on.
  final _skus = SkuBook(getIt<GetTakenSkus>());
  Timer? _skuTimer;
  int _skuRun = 0;
  late final _autoSku = AutoSku(_sku);

  @override
  void initState() {
    super.initState();
    _skus.categories = widget.categories;
    if (p == null) {
      _name.addListener(_scheduleSku);
      _category.addListener(_scheduleSku);
    }
  }

  @override
  void dispose() {
    _skuTimer?.cancel();
    for (final c in [_name, _sku, _barcode, _purchase, _price, _debtPrice, _stock, _category]) {
      c.dispose();
    }
    super.dispose();
  }

  void _scheduleSku() {
    if (p != null || _autoSku.touched) return;
    _skuTimer?.cancel();
    _skuTimer = Timer(const Duration(milliseconds: 300), _fillSku);
  }

  Future<void> _fillSku() async {
    final run = ++_skuRun;
    final sku = await _skus.next(category: _category.text, type: _type, name: _name.text);
    // A newer edit, or the user's own SKU, outranks a lookup that finished late.
    if (!mounted || run != _skuRun || _autoSku.touched) return;
    _autoSku.set(sku ?? '');
  }

  void _skuTyped(String text) {
    // Clearing the field hands the SKU back to the generator.
    if (_autoSku.typed(text) && !_autoSku.touched) _scheduleSku();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final p = this.p;
    final Result<Object?> result;
    if (p == null) {
      result = await _create();
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
        image: changed(_image, p.image),
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

  NewProduct _newProduct() => NewProduct(
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
        image: _image,
      );

  Future<Result<Object?>> _create() async {
    var result = await widget.onCreate(_newProduct());
    // The SKU was free when read, but another admin may have taken it since. The backend answers
    // 409 for a repeated SKU or barcode; with no barcode it can only be the SKU, so the next number
    // is tried instead of sending the admin back to retype it.
    for (var tries = 0; tries < 2 && !_autoSku.touched && _barcode.text.trim().isEmpty; tries++) {
      if (result is! Err<Object?> || result.failure is! ConflictFailure) break;
      final next = await _skus.next(category: _category.text, type: _type, name: _name.text, reserved: [_sku.text.trim()]);
      if (next == null || !mounted) break;
      _autoSku.set(next);
      result = await widget.onCreate(_newProduct());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final digits = [FilteringTextInputFormatter.digitsOnly];
    String? positive(String? v) => validationText(context, Validators.positiveInt(v));
    final stock = AppTextField(
      label: l10n.stock,
      controller: _stock,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) => validationText(context, Validators.quantity(v, whole: _unit == ProductUnit.pcs)),
    );
    Widget price(String label, TextEditingController c) => AppTextField(
          label: label,
          controller: c,
          prefixText: 'Rp',
          keyboardType: TextInputType.number,
          inputFormatters: digits,
          validator: positive,
        );

    // shadcn Field anatomy: a legend per group, 16 between fields, a divider and 24 between groups.
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Air between the dialog title and the first legend.
          const SizedBox(height: Space.sm),
          FormSection(title: l10n.sectionProductInfo, children: [
            AppTextField(label: l10n.productName, controller: _name, autofocus: true, validator: (v) => validationText(context, Validators.required(v))),
            FieldRow(children: [
              AppTextField(
                label: l10n.sku,
                controller: _sku,
                hint: p == null ? l10n.skuAutoHint : null,
                onChanged: p == null ? _skuTyped : null,
                validator: (v) => validationText(context, Validators.sku(v)),
              ),
              AppTextField(label: l10n.barcode, hint: l10n.barcodeHint, controller: _barcode, validator: (v) => validationText(context, Validators.barcode(v))),
            ]),
            if (p != null && p!.barcodeImage.isNotEmpty) BarcodeImage(image: p!.barcodeImage, semanticLabel: l10n.barcode),
            AppAutocomplete(
              label: l10n.category,
              hint: l10n.categoryNewHint,
              controller: _category,
              options: [for (final c in widget.categories) c.name],
              createLabel: (name) => l10n.createCategory(name),
              validator: (v) => validationText(context, Validators.categoryName(v)),
            ),
            FieldRow(children: [
              AppSelect<ProductType>(
                label: l10n.productType,
                value: _type,
                choices: [Choice(ProductType.physical, l10n.physical), Choice(ProductType.digital, l10n.digital)],
                onChanged: (t) {
                  setState(() => _type = t);
                  _scheduleSku();
                },
              ),
              AppSelect<ProductUnit>(
                label: l10n.unit,
                value: _unit,
                choices: [for (final u in ProductUnit.values) Choice(u, u.name)],
                onChanged: (u) => setState(() => _unit = u),
              ),
            ]),
          ]),
          FormSection(title: l10n.sectionPricing, children: [
            FieldRow(minWidth: 150, children: [
              price(l10n.purchasePrice, _purchase),
              price(l10n.sellingPrice, _price),
              price(l10n.debtPrice, _debtPrice),
            ]),
          ]),
          FormSection(title: l10n.sectionStockImage, last: true, children: [
            // Stock is set once at creation; later changes go through the stock action.
            if (p == null) Align(alignment: AlignmentDirectional.centerStart, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 240), child: stock)),
            ProductImageField(value: _image, onChanged: (v) => setState(() => _image = v)),
          ]),
          const SizedBox(height: Space.lg),
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
  final _formKey = GlobalKey<FormState>();
  final _delta = TextEditingController();
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _delta.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final delta = double.parse(_delta.text.trim().replaceAll(',', '.'));
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
    return Form(
      key: _formKey,
      child: Column(
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
            validator: (v) => validationText(context, Validators.quantity(v, whole: widget.product.unit == ProductUnit.pcs, signed: true)),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: Space.xl),
          FormActions(onSave: _save, saving: _saving, failure: _failure),
        ],
      ),
    );
  }
}
