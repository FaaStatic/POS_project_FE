import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/file_picker.dart';
import '../../../../common/file_saver.dart';
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

  List<TextEditingController> get all => [sku, barcode, name, purchase, price, debtPrice, stock, category];

  NewProduct toProduct() => NewProduct(
    sku: sku.text.trim(),
    barcode: barcode.text.trim(),
    name: name.text.trim(),
    unit: unit,
    purchasePrice: int.parse(purchase.text),
    sellingPrice: int.parse(price.text),
    sellingPriceDebt: int.parse(debtPrice.text),
    stock: double.parse(stock.text.replaceAll(',', '.')),
    category: category.text.trim(),
  );
}

class _BulkProductsPageState extends State<BulkProductsPage> {
  final _form = GlobalKey<FormState>();
  final _rows = [_Row(), _Row(), _Row()];

  @override
  void dispose() {
    for (final r in _rows) {
      for (final c in r.all) {
        c.dispose();
      }
    }
    super.dispose();
  }

  bool _isBlank(_Row r) => r.all.where((c) => c != r.stock).every((c) => c.text.trim().isEmpty);

  void _submit(BuildContext context) {
    if (!_form.currentState!.validate()) return;
    final filled = _rows.where((r) => !_isBlank(r)).toList();
    context.read<BulkProductsCubit>().submit([for (final r in filled) r.toProduct()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<BulkProductsCubit>(),
      child: BlocBuilder<BulkProductsCubit, BulkState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l10n.bulkTitle)),
          // Not a lazy list: every row must stay mounted so Form.validate() checks it.
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Space.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.result != null) _ResultSummary(result: state.result!),
                  if (state.failure != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.lg),
                      child: Text(failureText(context, state.failure!), style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  _ImportFromFile(state: state),
                  const SizedBox(height: Space.xxl),
                  Text(l10n.manualTitle, style: theme.textTheme.titleLarge),
                  const SizedBox(height: Space.sm),
                  Text(l10n.bulkHint, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: Space.lg),
                  for (var i = 0; i < _rows.length; i++) _rowEditor(context, i),
                  const SizedBox(height: Space.md),
                  Wrap(
                    spacing: Space.md,
                    runSpacing: Space.md,
                    children: [
                      AppButton(
                        label: l10n.addRow,
                        icon: Iconsax.add_copy,
                        variant: AppButtonVariant.outline,
                        onPressed: () => setState(() => _rows.add(_Row())),
                      ),
                      AppButton(
                        label: l10n.uploadBulk,
                        large: true,
                        loading: state.saving,
                        onPressed: () => _submit(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowEditor(BuildContext context, int i) {
    final l10n = AppLocalizations.of(context);
    final r = _rows[i];
    final digits = [FilteringTextInputFormatter.digitsOnly];
    String? need(String? Function(String?) rule, String? v) => _isBlank(r) ? null : validationText(context, rule(v));
    Widget field(
      String label,
      TextEditingController c, {
      double width = 160,
      String? Function(String?)? rule,
      bool number = false,
    }) => SizedBox(
      width: width,
      child: AppTextField(
        label: label,
        controller: c,
        keyboardType: number ? TextInputType.number : null,
        inputFormatters: number ? digits : null,
        validator: rule == null ? null : (v) => need(rule, v),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(Radii.medium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Wrap(
            spacing: Space.md,
            runSpacing: Space.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(width: 72, child: Text(l10n.row(i + 1), style: Theme.of(context).textTheme.labelLarge)),
              field(l10n.sku, r.sku, rule: Validators.sku),
              field(l10n.barcode, r.barcode, rule: Validators.barcode),
              field(l10n.productName, r.name, width: 240, rule: Validators.required),
              SizedBox(
                width: 120,
                child: AppSelect<ProductUnit>(
                  label: l10n.unit,
                  value: r.unit,
                  choices: [for (final u in ProductUnit.values) Choice(u, u.name)],
                  onChanged: (u) => setState(() => r.unit = u),
                ),
              ),
              field(l10n.purchasePrice, r.purchase, rule: Validators.positiveInt, number: true),
              field(l10n.sellingPrice, r.price, rule: Validators.positiveInt, number: true),
              field(l10n.debtPrice, r.debtPrice, rule: Validators.positiveInt, number: true),
              field(l10n.stock, r.stock, width: 100, rule: Validators.nonNegativeNumber),
              field(l10n.category, r.category, rule: Validators.categoryName),
              if (_rows.length > 1)
                AppButton(
                  label: l10n.removeRow,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => setState(() {
                    for (final c in _rows.removeAt(i).all) {
                      c.dispose();
                    }
                  }),
                ),
            ],
          ),
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
      children: [
        Text(l10n.importTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: Space.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(l10n.importHint, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
        const SizedBox(height: Space.lg),
        Wrap(spacing: Space.md, runSpacing: Space.md, crossAxisAlignment: WrapCrossAlignment.center, children: [
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
        ]),
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
