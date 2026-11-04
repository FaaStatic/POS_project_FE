import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';
import 'failure_text.dart';
import 'widgets.dart';

/// Opens the add-credit form and resolves true once the credit was saved.
///
/// With [customer] the form is for that customer and shows their [current] debt and what it
/// becomes; without, the customer is picked through [search].
Future<bool> showAddDebt(
  BuildContext context, {
  Customer? customer,
  int current = 0,
  Future<List<Customer>> Function(String query)? search,
  required Future<Result<void>> Function(String customerId, int amount, DateTime? due, String? note) submit,
}) async {
  assert(customer != null || search != null, 'without a customer the form needs a search to pick one');
  final l10n = AppLocalizations.of(context);
  final saved = await showFormSurface<bool>(
    context,
    title: customer == null ? l10n.addManualDebt : l10n.addDebt,
    child: _AddDebtForm(customer: customer, current: current, search: search, submit: submit),
  );
  return saved == true;
}

class _AddDebtForm extends StatefulWidget {
  const _AddDebtForm({required this.customer, required this.current, required this.search, required this.submit});
  final Customer? customer;
  final int current;
  final Future<List<Customer>> Function(String query)? search;
  final Future<Result<void>> Function(String customerId, int amount, DateTime? due, String? note) submit;

  @override
  State<_AddDebtForm> createState() => _AddDebtFormState();
}

class _AddDebtFormState extends State<_AddDebtForm> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  late Customer? _customer = widget.customer;
  bool _noCustomer = false;
  DateTime? _due;
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final customer = _customer;
    if (customer == null) {
      setState(() => _noCustomer = true);
      return;
    }
    setState(() => _saving = true);
    final result = await widget.submit(customer.id, int.tryParse(_amount.text) ?? 0, _due, _note.text);
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
    final theme = Theme.of(context);
    final today = DateTime.now();
    final fixed = widget.customer;
    final added = int.tryParse(_amount.text) ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fixed != null) ...[
          Text(fixed.name, style: theme.textTheme.titleMedium),
          const SizedBox(height: Space.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(l10n.currentDebt, style: theme.textTheme.bodyLarge),
              Text(money(context, widget.current), style: theme.textTheme.bodyLarge?.tabular),
            ],
          ),
        ] else
          AppSearchSelect<Customer>(
            label: l10n.pickCustomer,
            autofocus: true,
            search: widget.search!,
            labelOf: (c) => c.phone.isEmpty ? c.name : '${c.name} · ${c.phone}',
            errorText: _noCustomer ? validationText(context, 'required') : null,
            onChanged: (c) => setState(() {
              _customer = c;
              _noCustomer = false;
            }),
          ),
        const SizedBox(height: Space.lg),
        AppTextField(
          label: l10n.amount,
          controller: _amount,
          autofocus: fixed != null,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => setState(() {}),
        ),
        if (fixed != null && added > 0) ...[
          const SizedBox(height: Space.sm),
          Text(
            l10n.debtBecomes(money(context, widget.current + added)),
            style: theme.textTheme.titleSmall?.tabular,
          ),
        ],
        const SizedBox(height: Space.lg),
        AppTextField(
          label: l10n.debtNote,
          hint: l10n.debtNoteHint,
          controller: _note,
          inputFormatters: [LengthLimitingTextInputFormatter(AddManualDebt.noteMaxLength)],
        ),
        const SizedBox(height: Space.lg),
        // Full width like the inputs above; height 0 lets the date wrap at large text.
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: AppSizes.of(context).control),
          child: ShadDatePicker(
            width: 0,
            height: 0,
            expands: true,
            buttonPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
            placeholder: Text(l10n.dueDate),
            selected: _due,
            formatDate: (d) => dateText(context, d),
            fromMonth: today,
            toMonth: DateTime(today.year + 2),
            selectableDayPredicate: (d) => !d.isBefore(DateUtils.dateOnly(today)),
            onChanged: (d) => setState(() => _due = d),
          ),
        ),
        const SizedBox(height: Space.xl),
        FormActions(onSave: _save, saving: _saving, failure: _failure),
      ],
    );
  }
}
