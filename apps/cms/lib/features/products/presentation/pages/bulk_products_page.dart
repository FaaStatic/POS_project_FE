import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/auto_sku.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/file_picker.dart';
import '../../../../common/feedback.dart';
import '../../../../common/file_saver.dart';
import '../../../../common/form_layout.dart';
import '../../../../common/product_image_field.dart';
import '../../../../common/sku_book.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/bulk_products_cubit.dart';

/// Multi-row form sent as one CSV to /products/bulk. A USB scanner can type
/// straight into each row's barcode field.
class BulkProductsPage extends StatefulWidget {
  const BulkProductsPage({super.key});

  @override
  State<BulkProductsPage> createState() => _BulkProductsPageState();
}

class _Row {
  final sku = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final purchase = TextEditingController();
  final price = TextEditingController();
  final debtPrice = TextEditingController();
  final stock = TextEditingController(text: '0');
  final category = TextEditingController();
  ProductUnit unit = ProductUnit.pcs;
  ProductType type = ProductType.physical;

  /// Follows the name, category, and type until the user types this row's SKU.
  late final autoSku = AutoSku(sku);

  /// Raw base64 of the chosen picture, empty for none.
  String image = '';

  List<TextEditingController> get all => [sku, barcode, name, purchase, price, debtPrice, stock, category];

  NewProduct toProduct() => NewProduct(
    sku: sku.text.trim(),
    barcode: barcode.text.trim(),
    name: name.text.trim(),
    unit: unit,
    type: type,
    purchasePrice: int.parse(purchase.text),
    sellingPrice: int.parse(price.text),
    sellingPriceDebt: int.parse(debtPrice.text),
    stock: double.parse(stock.text.replaceAll(',', '.')),
    category: category.text.trim(),
    image: image,
  );
}

class _BulkProductsPageState extends State<BulkProductsPage> {
  /// Wide enough for a row's fields in one line each, narrow enough to read.
  static const _maxWidth = 1040.0;

  /// The backend refuses a request body over 25 MB; the CSV carries every picture as base64.
  static const _maxImagesBytes = 20 * 1024 * 1024;

  final _form = GlobalKey<FormState>();
  late final _rows = [_newRow(), _newRow(), _newRow()];

  final _skus = SkuBook(getIt<GetTakenSkus>());
  List<String> _categoryNames = const [];
  Timer? _skuTimer;
  int _skuRun = 0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await getIt<GetCategories>()();
    if (!mounted || result is! Ok<List<Category>>) return;
    _skus.categories = result.value;
    setState(() => _categoryNames = [for (final c in result.value) c.name]);
    _scheduleSkus();
  }

  /// A row whose name or category changes asks for its SKU again after a short pause.
  _Row _newRow() {
    final r = _Row();
    r.name.addListener(_scheduleSkus);
    r.category.addListener(_scheduleSkus);
    return r;
  }

  void _scheduleSkus() {
    _skuTimer?.cancel();
    _skuTimer = Timer(const Duration(milliseconds: 300), _fillSkus);
  }

  /// Top to bottom, so each row numbers after the rows above it. SKUs the user typed in rows below
  /// count as taken too: the generator must not hand out a number a later row already holds.
  Future<void> _fillSkus() async {
    final run = ++_skuRun;
    for (var i = 0; i < _rows.length; i++) {
      final r = _rows[i];
      if (r.autoSku.touched) continue;
      final reserved = [
        for (final (j, o) in _rows.indexed)
          if (j != i && (j < i || o.autoSku.touched) && o.sku.text.trim().isNotEmpty) o.sku.text.trim(),
      ];
      final sku = await _skus.next(category: r.category.text, type: r.type, name: r.name.text, reserved: reserved);
      if (!mounted || run != _skuRun || i >= _rows.length || !identical(_rows[i], r) || r.autoSku.touched) return;
      r.autoSku.set(sku ?? '');
    }
  }

  void _skuTyped(_Row r, String text) {
    if (r.autoSku.typed(text)) _scheduleSkus();
  }

  @override
  void dispose() {
    _skuTimer?.cancel();
    for (final r in _rows) {
      for (final c in r.all) {
        c.dispose();
      }
    }
    super.dispose();
  }

  bool _isBlank(_Row r) => r.image.isEmpty && r.all.where((c) => c != r.stock).every((c) => c.text.trim().isEmpty);

  void _submit(BuildContext context) {
    if (!_form.currentState!.validate()) return;
    final filled = _rows.where((r) => !_isBlank(r)).toList();
    if (filled.fold(0, (sum, r) => sum + r.image.length) > _maxImagesBytes) {
      toast(context, AppLocalizations.of(context).bulkImagesTooLarge);
      return;
    }
    context.read<BulkProductsCubit>().submit([for (final r in filled) r.toProduct()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // At large text two stacked buttons would eat a quarter of the screen, so they scroll with the rows.
    final pinned = MediaQuery.textScalerOf(context).scale(1) <= 1.3;
    return BlocProvider(
      create: (_) => getIt<BulkProductsCubit>(),
      child: BlocBuilder<BulkProductsCubit, BulkState>(
        builder: (context, state) {
          // Full width up to the cap, so the two buttons sit at opposite ends.
          final actions = SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.md,
              runSpacing: Space.md,
              children: [
                AppButton(
                  label: l10n.addRow,
                  icon: Iconsax.add_copy,
                  variant: AppButtonVariant.outline,
                  onPressed: () => setState(() => _rows.add(_newRow())),
                ),
                AppButton(
                  label: l10n.uploadBulk,
                  large: true,
                  loading: state.saving,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          );
          return Scaffold(
            appBar: AppBar(title: Text(l10n.bulkTitle)),
            // Not a lazy list: every row must stay mounted so Form.validate() checks it.
            body: Form(
              key: _form,
              child: SingleChildScrollView(
                child: ConstrainedBody(
                  maxWidth: _maxWidth,
                  padding: const EdgeInsets.all(Space.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.result != null) _ResultSummary(result: state.result!),
                      if (state.failure != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.lg),
                          child: Text(
                            failureText(context, state.failure!),
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      FormSection(
                        title: l10n.importTitle,
                        children: [_ImportFromFile(state: state)],
                      ),
                      FormSection(
                        title: l10n.manualTitle,
                        last: true,
                        children: [
                          Text(
                            l10n.bulkHint,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          for (var i = 0; i < _rows.length; i++) _rowEditor(context, i),
                        ],
                      ),
                      if (!pinned) ...[const SizedBox(height: Space.lg), actions],
                    ],
                  ),
                ),
              ),
            ),
            // Pinned so Simpan stays in reach however many rows are added.
            bottomNavigationBar: pinned
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
                    ),
                    child: SafeArea(
                      top: false,
                      // heightFactor: the bar wraps its buttons instead of filling the screen.
                      child: Center(
                        heightFactor: 1,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: _maxWidth),
                          child: Padding(padding: const EdgeInsets.all(Space.lg), child: actions),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  /// One product: its identity on the first line of fields, units, prices, and stock on the second.
  Widget _rowEditor(BuildContext context, int i) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = _rows[i];
    final digits = [FilteringTextInputFormatter.digitsOnly];
    String? need(String? Function(String?) rule, String? v) => _isBlank(r) ? null : validationText(context, rule(v));
    Widget field(
      String label,
      TextEditingController c, {
      String? Function(String?)? rule,
      bool number = false,
      bool money = false,
      String? hint,
      ValueChanged<String>? onChanged,
    }) => AppTextField(
      label: label,
      controller: c,
      hint: hint,
      onChanged: onChanged,
      prefixText: money ? 'Rp' : null,
      keyboardType: number ? TextInputType.number : null,
      inputFormatters: number ? digits : null,
      validator: rule == null ? null : (v) => need(rule, v),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(Radii.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(header: true, child: Text(l10n.row(i + 1), style: theme.textTheme.titleSmall)),
                ),
                if (_rows.length > 1)
                  IconButton(
                    tooltip: l10n.removeRow,
                    icon: const Icon(Iconsax.trash_copy, size: 20),
                    onPressed: () => setState(() {
                      for (final c in _rows.removeAt(i).all) {
                        c.dispose();
                      }
                      _scheduleSkus();
                    }),
                  ),
              ],
            ),
            FieldRow(
              wrap: true,
              minWidth: 170,
              flex: const [2, 1, 1, 1],
              children: [
                field(l10n.productName, r.name, rule: Validators.required),
                field(l10n.sku, r.sku, rule: Validators.sku, hint: l10n.skuAutoHint, onChanged: (v) => _skuTyped(r, v)),
                field(l10n.barcode, r.barcode, rule: Validators.barcode, hint: l10n.barcodeHint),
                AppAutocomplete(
                  label: l10n.category,
                  hint: l10n.categoryNewHint,
                  controller: r.category,
                  options: _categoryNames,
                  createLabel: (name) => l10n.createCategory(name),
                  validator: (v) => need(Validators.categoryName, v),
                ),
              ],
            ),
            FieldRow(
              wrap: true,
              minWidth: 130,
              children: [
                AppSelect<ProductType>(
                  label: l10n.productType,
                  value: r.type,
                  choices: [Choice(ProductType.physical, l10n.physical), Choice(ProductType.digital, l10n.digital)],
                  onChanged: (t) {
                    setState(() => r.type = t);
                    _scheduleSkus();
                  },
                ),
                AppSelect<ProductUnit>(
                  label: l10n.unit,
                  value: r.unit,
                  choices: [for (final u in ProductUnit.values) Choice(u, u.name)],
                  onChanged: (u) => setState(() => r.unit = u),
                ),
                field(l10n.purchasePrice, r.purchase, rule: Validators.positiveInt, number: true, money: true),
                field(l10n.sellingPrice, r.price, rule: Validators.positiveInt, number: true, money: true),
                field(l10n.debtPrice, r.debtPrice, rule: Validators.positiveInt, number: true, money: true),
                field(l10n.stock, r.stock, rule: Validators.nonNegativeNumber),
              ],
            ),
            ProductImageField(value: r.image, onChanged: (v) => setState(() => r.image = v)),
          ],
        ),
      ),
    );
  }
}

class _ImportFromFile extends StatelessWidget {
  const _ImportFromFile({required this.state});
  final BulkState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cubit = context.read<BulkProductsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.lg,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            l10n.importHint,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        Wrap(
          spacing: Space.md,
          runSpacing: Space.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: state.fileName == null ? l10n.pickFile : l10n.importing(state.fileName!),
              icon: Iconsax.document_upload_copy,
              loading: state.saving && state.fileName != null,
              onPressed: state.saving
                  ? null
                  : () async {
                      final file = await pickFile(accept: ImportProductsFile.extensions);
                      if (file != null) await cubit.importFile(file.bytes, file.name);
                    },
            ),
            AppButton(
              label: l10n.downloadTemplate,
              icon: Iconsax.document_download_copy,
              variant: AppButtonVariant.outline,
              onPressed: () => saveFile(utf8.encode(_template), 'template-produk.csv', mime: 'text/csv'),
            ),
          ],
        ),
      ],
    );
  }

  static final _template = ProductModel.toCsv(const [
    NewProduct(
      sku: 'IDM-GRG',
      barcode: '8992388101012',
      name: 'Indomie Goreng',
      purchasePrice: 2800,
      sellingPrice: 3500,
      sellingPriceDebt: 4000,
      stock: 40,
      category: 'Mie Instan',
    ),
  ]);
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({required this.result});
  final BulkImportResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasErrors = result.rowErrors.isNotEmpty || result.duplicateInFile.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(
            label: l10n.bulkResult(result.inserted, result.updated),
            tone: hasErrors ? BadgeTone.warning : BadgeTone.success,
          ),
          // CSV line 1 is the header, so form row = line - 1.
          for (final e in result.rowErrors) Text(l10n.bulkRowError(e.line - 1, e.message)),
          if (result.duplicateInFile.isNotEmpty) Text(l10n.bulkDuplicate(result.duplicateInFile.join(', '))),
        ],
      ),
    );
  }
}
