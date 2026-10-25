import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/feedback.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/debts_cubit.dart';

class DebtsPage extends StatelessWidget {
  const DebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<DebtsCubit>()..load(),
      child: Builder(builder: (context) {
        final cubit = context.read<DebtsCubit>();
        final state = context.watch<DebtsCubit>().state;
        final theme = Theme.of(context);
        return CmsPage(
          title: l10n.debtsTitle,
          actions: [FilledButton.icon(onPressed: () => _addManual(context, cubit), icon: const Icon(Iconsax.add), label: Text(l10n.addManualDebt))],
          body: Column(children: [
            FilterBar(children: [
              FilterChip(label: Text(l10n.unpaidOnly), selected: cubit.query.unpaidOnly, onSelected: cubit.unpaidOnly),
              SizedBox(width: 300, child: SearchField(hint: l10n.searchCustomer, onChanged: cubit.search)),
            ]),
            Expanded(
              child: PagedBody<Debt>(
                state: state,
                emptyMessage: l10n.debtsEmpty,
                onRetry: cubit.load,
                builder: (items) => ResponsiveTable<Debt>(
                  rows: items,
                  rowKey: (d) => d.id,
                  onTap: (d) => context.push('/customers/${d.customerId}'),
                  hasMore: state.hasNext,
                  loadingMore: state.loadingMore,
                  onLoadMore: cubit.loadMore,
                  columns: [
                    TableColumnSpec(label: l10n.customerName, flex: 2, cell: (_, d) => Text(d.customerName)),
                    TableColumnSpec(label: l10n.remaining, numeric: true, cell: (c, d) => Text(money(c, d.remaining), style: theme.textTheme.bodyMedium?.tabular)),
                    TableColumnSpec(label: l10n.total, numeric: true, secondary: true, cell: (c, d) => Text(money(c, d.total), style: theme.textTheme.bodyMedium?.tabular)),
                    TableColumnSpec(label: l10n.date, cell: (c, d) => Text(dateText(c, d.date))),
                    TableColumnSpec(label: l10n.status, cell: (_, d) => StatusBadge(label: d.paid ? l10n.debtPaid : l10n.debtUnpaid, tone: d.paid ? BadgeTone.success : BadgeTone.warning)),
                  ],
                  actions: (context, d) => d.paid
                      ? const SizedBox.shrink()
                      : OutlinedButton(onPressed: () => _pay(context, cubit, d), child: Text(l10n.receivePayment)),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }

  Future<void> _pay(BuildContext context, DebtsCubit cubit, Debt d) async {
    final l10n = AppLocalizations.of(context);
    final receipt = await showFormSurface<DebtPaymentReceipt>(
      context,
      title: '${l10n.receivePayment} · ${d.customerName}',
      child: _PayForm(debt: d, cubit: cubit),
    );
    if (receipt != null && context.mounted) toast(context, l10n.paymentRecorded(money(context, receipt.remaining)));
  }

  Future<void> _addManual(BuildContext context, DebtsCubit cubit) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showFormSurface<bool>(context, title: l10n.addManualDebt, child: _ManualDebtForm(cubit: cubit));
    if (ok == true && context.mounted) toast(context, l10n.debtAdded);
  }
}

class _PayForm extends StatefulWidget {
  const _PayForm({required this.debt, required this.cubit});
  final Debt debt;
  final DebtsCubit cubit;

  @override
  State<_PayForm> createState() => _PayFormState();
}

class _PayFormState extends State<_PayForm> {
  final _amount = TextEditingController();
  final _key = DebtsCubit.newKey();
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final result = await widget.cubit.pay(widget.debt, int.tryParse(_amount.text) ?? 0, _key);
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        Navigator.pop(context, value);
      case Err(:final failure):
        setState(() {
          _saving = false;
          _failure = failure;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = widget.debt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('${l10n.remaining}: ${money(context, d.remaining)} / ${money(context, d.total)}', style: Theme.of(context).textTheme.titleMedium?.tabular),
        const SizedBox(height: Space.lg),
        AppTextField(
          label: l10n.paymentAmount,
          controller: _amount,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (_) => _save(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: () => _amount.text = '${d.remaining}', child: Text(l10n.payFull(money(context, d.remaining)))),
        ),
        const SizedBox(height: Space.lg),
        FormActions(onSave: _save, saving: _saving, failure: _failure),
      ],
    );
  }
}

class _ManualDebtForm extends StatefulWidget {
  const _ManualDebtForm({required this.cubit});
  final DebtsCubit cubit;

  @override
  State<_ManualDebtForm> createState() => _ManualDebtFormState();
}

class _ManualDebtFormState extends State<_ManualDebtForm> {
  final _amount = TextEditingController();
  Customer? _customer;
  DateTime? _due;
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final customer = _customer;
    if (customer == null) {
      setState(() => _failure = const ValidationFailure('required'));
      return;
    }
    setState(() => _saving = true);
    final result = await widget.cubit.addManual(customer.id, int.tryParse(_amount.text) ?? 0, _due);
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
        Autocomplete<Customer>(
          displayStringForOption: (c) => c.phone.isEmpty ? c.name : '${c.name} · ${c.phone}',
          optionsBuilder: (v) => v.text.trim().length < 2 ? const <Customer>[] : widget.cubit.findCustomers(v.text.trim()),
          onSelected: (c) => setState(() => _customer = c),
          fieldViewBuilder: (context, controller, focus, _) => TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.pickCustomer, helperText: _customer?.name),
          ),
        ),
        const SizedBox(height: Space.lg),
        AppTextField(
          label: l10n.amount,
          controller: _amount,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: Space.lg),
        OutlinedButton.icon(
          icon: const Icon(Iconsax.calendar_1),
          label: Text(_due == null ? l10n.dueDate : dateText(context, _due)),
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(context: context, firstDate: now, lastDate: DateTime(now.year + 2), initialDate: _due ?? now);
            if (picked != null) setState(() => _due = picked);
          },
        ),
        const SizedBox(height: Space.xl),
        FormActions(onSave: _save, saving: _saving, failure: _failure),
      ],
    );
  }
}
