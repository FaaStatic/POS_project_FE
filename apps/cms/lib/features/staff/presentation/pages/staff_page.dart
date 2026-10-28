import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../app/shell/cms_page.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/feedback.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/staff_cubit.dart';

class StaffPage extends StatelessWidget {
  const StaffPage({super.key, this.openAdd = false});

  /// Set by the dashboard quick action.
  final bool openAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<StaffCubit>()..load(),
      child: Builder(builder: (context) {
        final cubit = context.read<StaffCubit>();
        if (openAdd) _openOnce(context, () => _add(context));
        final state = context.watch<StaffCubit>().state;
        return CmsPage(
          title: l10n.staffTitle,
          actions: [
            AppButton(label: l10n.addStaff, icon: Iconsax.user_add_copy, onPressed: () => _add(context)),
          ],
          body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [FilterBar(children: [
                AppTabs<bool>(
                  choices: [Choice(false, l10n.active), Choice(true, l10n.inactive)],
                  value: cubit.query.inactive,
                  onChanged: cubit.showInactive,
                ),
                SizedBox(width: 320, child: SearchField(hint: l10n.search, onChanged: cubit.search)),
              ]),
              Expanded(
                child: PagedBody<Staff>(
                  state: state,
                  emptyMessage: cubit.query.inactive ? l10n.staffInactiveEmpty : l10n.staffEmpty,
                  emptyAction: cubit.query.inactive ? null : l10n.addStaff,
                  onEmptyAction: () => _add(context),
                  onRetry: cubit.load,
                  builder: (items) => ResponsiveTable<Staff>(
                    rows: items,
                    rowKey: (s) => s.id,
                    hasMore: state.hasNext,
                    loadingMore: state.loadingMore,
                    onLoadMore: cubit.loadMore,
                    columns: [
                      TableColumnSpec(label: 'Username', flex: 2, cell: (_, s) => Text(s.username)),
                      TableColumnSpec(label: l10n.role, cell: (_, s) => Text(s.role.isSuper ? l10n.roleSuper : l10n.roleStaff)),
                      TableColumnSpec(label: l10n.createdAt, secondary: true, cell: (c, s) => Text(dateText(c, s.createdAt))),
                    ],
                    actions: (context, s) => ActionsMenu(actions: [
                      if (s.active) ...[
                        RowAction(l10n.resetPassword, () => _reset(context, s)),
                        RowAction(l10n.deactivate, () => report(context, cubit.deactivate(s), l10n.staffDeactivated)),
                      ] else
                        RowAction(l10n.restore, () => report(context, cubit.restore(s), l10n.staffRestored)),
                      RowAction(l10n.purge, () => _purge(context, s), destructive: true),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _add(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<StaffCubit>();
    final ok = await showFormSurface<bool>(
      context,
      title: l10n.addStaff,
      child: _CredentialsForm(withUsername: true, onSubmit: (u, p) => cubit.register(u, p)),
    );
    if (ok == true && context.mounted) toast(context, l10n.staffAdded);
  }

  Future<void> _reset(BuildContext context, Staff s) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<StaffCubit>();
    final ok = await showFormSurface<bool>(
      context,
      title: '${l10n.resetPassword} · ${s.username}',
      child: _CredentialsForm(withUsername: false, hint: l10n.resetPasswordHint, onSubmit: (_, p) => cubit.resetPassword(s, p)),
    );
    if (ok == true && context.mounted) toast(context, l10n.passwordReset);
  }

  Future<void> _purge(BuildContext context, Staff s) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<StaffCubit>();
    final typed = await showTypeToConfirm(context, name: s.username, hint: l10n.purgeStaffHint);
    if (typed == null || !context.mounted) return;
    final result = await cubit.purge(s, typed);
    if (!context.mounted) return;
    showResult(context, result, switch (result) {
      Ok(value: PurgeMode.anonymized) => l10n.purgedAnonymized,
      _ => l10n.purgedDeleted,
    });
  }
}

/// Username + password for a new staff, or just a new password for a reset.
/// Username cannot be changed from the CMS.
class _CredentialsForm extends StatefulWidget {
  const _CredentialsForm({required this.withUsername, required this.onSubmit, this.hint});
  final bool withUsername;
  final String? hint;
  final Future<Result<void>> Function(String username, String password) onSubmit;

  @override
  State<_CredentialsForm> createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<_CredentialsForm> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final result = await widget.onSubmit(_username.text, _password.text);
    if (!mounted) return;
    switch (result) {
      case Ok():
        Navigator.pop(context, true);
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
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.hint != null) ...[Text(widget.hint!), const SizedBox(height: Space.lg)],
          if (widget.withUsername) ...[
            AppTextField(
              label: l10n.username,
              controller: _username,
              autofocus: true,
              validator: (v) => validationText(context, Validators.username(v)),
            ),
            const SizedBox(height: Space.lg),
          ],
          AppTextField(
            label: widget.withUsername ? l10n.password : l10n.newPassword,
            controller: _password,
            password: true,
            autofocus: !widget.withUsername,
            validator: (v) => validationText(context, Validators.password(v)),
            onSubmitted: (_) => _save(),
          ),
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
