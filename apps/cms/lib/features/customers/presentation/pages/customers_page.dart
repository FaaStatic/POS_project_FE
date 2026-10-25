import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/feedback.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/customers_cubit.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key, this.openAdd = false});

  /// Set by the dashboard quick action.
  final bool openAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<CustomersCubit>()..load(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CustomersCubit>();
          if (openAdd) _openOnce(context, () => openCustomerForm(context, cubit));
          final state = context.watch<CustomersCubit>().state;
          return CmsPage(
            title: l10n.customersTitle,
            actions: [
              FilledButton.icon(
                onPressed: () => openCustomerForm(context, cubit),
                icon: const Icon(Iconsax.user_add),
                label: Text(l10n.addCustomer),
              ),
            ],
            body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [FilterBar(
                  children: [
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: false, label: Text(l10n.active)),
                        ButtonSegment(value: true, label: Text(l10n.inactive)),
                      ],
                      selected: {cubit.query.inactive},
                      onSelectionChanged: (s) => cubit.showInactive(s.first),
                    ),
                    SizedBox(
                      width: 320,
                      child: SearchField(hint: l10n.search, onChanged: cubit.search),
                    ),
                  ],
                ),
                Expanded(
                  child: PagedBody<Customer>(
                    state: state,
                    emptyMessage: cubit.query.inactive ? l10n.customersInactiveEmpty : l10n.customersEmpty,
                    emptyAction: cubit.query.inactive ? null : l10n.addCustomer,
                    onEmptyAction: () => openCustomerForm(context, cubit),
                    onRetry: cubit.load,
                    builder: (items) => ResponsiveTable<Customer>(
                      rows: items,
                      rowKey: (c) => c.id,
                      onTap: (c) => context.push('/customers/${c.id}'),
                      hasMore: state.hasNext,
                      loadingMore: state.loadingMore,
                      onLoadMore: cubit.loadMore,
                      columns: [
                        TableColumnSpec(label: l10n.customerName, flex: 2, cell: (_, c) => Text(c.name)),
                        TableColumnSpec(
                          label: l10n.customerPhone,
                          cell: (_, c) => Text(c.phone.isEmpty ? '-' : c.phone),
                        ),
                        TableColumnSpec(
                          label: l10n.customerAddress,
                          secondary: true,
                          flex: 2,
                          cell: (_, c) => Text(c.address.isEmpty ? '-' : c.address),
                        ),
                      ],
                      actions: (context, c) => ActionsMenu(
                        actions: [
                          RowAction(l10n.edit, () => openCustomerForm(context, cubit, existing: c)),
                          if (c.active)
                            RowAction(
                              l10n.deactivate,
                              () => report(context, cubit.deactivate(c), l10n.customerDeactivated),
                            )
                          else
                            RowAction(l10n.restore, () => report(context, cubit.restore(c), l10n.customerRestored)),
                          RowAction(l10n.purge, () => _purge(context, cubit, c), destructive: true),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _purge(BuildContext context, CustomersCubit cubit, Customer c) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.purgeTitle(c.name),
      message: l10n.purgeCustomerHint,
      confirmLabel: l10n.purge,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final result = await cubit.purge(c);
    if (!context.mounted) return;
    showResult(context, result, switch (result) {
      Ok(value: PurgeMode.anonymized) => l10n.purgedAnonymized,
      _ => l10n.purgedDeleted,
    });
  }
}

Future<void> openCustomerForm(BuildContext context, CustomersCubit cubit, {Customer? existing}) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showFormSurface<bool>(
    context,
    title: existing == null ? l10n.addCustomer : l10n.editCustomer,
    child: _CustomerForm(
      existing: existing,
      onSubmit: (input) async => existing == null ? await cubit.create(input) : await cubit.update(existing, input),
    ),
  );
  if (ok == true && context.mounted) toast(context, l10n.saved);
}

class _CustomerForm extends StatefulWidget {
  const _CustomerForm({required this.onSubmit, this.existing});
  final Customer? existing;
  final Future<Result<Object?>> Function(CustomerInput input) onSubmit;

  @override
  State<_CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<_CustomerForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _phone = TextEditingController(text: widget.existing?.phone);
  late final _address = TextEditingController(text: widget.existing?.address);
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final result = await widget.onSubmit(CustomerInput(name: _name.text, phone: _phone.text, address: _address.text));
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
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.customerName,
            controller: _name,
            autofocus: true,
            validator: (v) => validationText(context, Validators.required(v)),
          ),
          const SizedBox(height: Space.lg),
          AppTextField(label: l10n.customerPhone, controller: _phone, keyboardType: TextInputType.phone),
          const SizedBox(height: Space.lg),
          AppTextField(label: l10n.customerAddress, controller: _address, maxLines: 2),
          const SizedBox(height: Space.xl),
          FormActions(onSave: _save, saving: _saving, failure: _failure),
        ],
      ),
    );
  }
}

final _opened = Expando<bool>();

/// Opens the add form once per page instance after the first frame.
void _openOnce(BuildContext context, VoidCallback open) {
  final element = context as Element;
  if (_opened[element] == true) return;
  _opened[element] = true;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) open();
  });
}
