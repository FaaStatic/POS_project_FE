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
import '../bloc/categories_cubit.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<CategoriesCubit>()..load(),
      child: Builder(builder: (context) {
        final cubit = context.read<CategoriesCubit>();
        final state = context.watch<CategoriesCubit>().state;
        Widget body;
        if (state.loading && state.items.isEmpty) {
          body = const LoadingView();
        } else if (state.failure != null) {
          body = ErrorState(message: l10n.loadFailed(failureText(context, state.failure!)), onRetry: cubit.load);
        } else if (state.items.isEmpty) {
          body = EmptyState(message: l10n.categoriesEmpty, actionLabel: l10n.addCategory, onAction: () => _name(context, cubit));
        } else {
          body = ResponsiveTable<Category>(
            rows: state.items,
            rowKey: (c) => c.id,
            columns: [
              TableColumnSpec(label: l10n.categoryName, flex: 2, cell: (_, c) => Text(c.name)),
              TableColumnSpec(label: l10n.navProducts, cell: (_, c) => Text(l10n.productCount(c.productCount))),
            ],
            actions: (context, c) => Wrap(spacing: Space.sm, alignment: WrapAlignment.end, children: [
              AppButton(label: l10n.rename, variant: AppButtonVariant.outline, onPressed: () => _name(context, cubit, existing: c)),
              Tooltip(
                message: c.productCount > 0 ? l10n.categoryInUse(c.productCount) : '',
                child: AppButton(
                  label: l10n.delete,
                  variant: AppButtonVariant.destructiveGhost,
                  onPressed: c.productCount > 0 ? null : () => _delete(context, cubit, c),
                ),
              ),
            ]),
          );
        }
        return CmsPage(
          title: l10n.categoriesTitle,
          actions: [AppButton(label: l10n.addCategory, icon: Iconsax.add_copy, onPressed: () => _name(context, cubit))],
          body: body,
        );
      }),
    );
  }

  Future<void> _name(BuildContext context, CategoriesCubit cubit, {Category? existing}) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showFormSurface<bool>(
      context,
      title: existing == null ? l10n.addCategory : l10n.rename,
      child: _NameForm(
        initial: existing?.name,
        onSubmit: (name) async => existing == null ? await cubit.create(name) : await cubit.rename(existing, name),
      ),
    );
    if (ok == true && context.mounted) toast(context, l10n.saved);
  }

  Future<void> _delete(BuildContext context, CategoriesCubit cubit, Category c) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showConfirmDialog(context, title: l10n.deleteCategoryTitle(c.name), confirmLabel: l10n.delete, destructive: true);
    if (!ok || !context.mounted) return;
    final result = await cubit.delete(c);
    if (context.mounted) showResult(context, result, l10n.categoryDeleted);
  }
}

class _NameForm extends StatefulWidget {
  const _NameForm({required this.onSubmit, this.initial});
  final String? initial;
  final Future<Result<Object?>> Function(String name) onSubmit;

  @override
  State<_NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<_NameForm> {
  late final _name = TextEditingController(text: widget.initial);
  bool _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final result = await widget.onSubmit(_name.text);
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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(label: AppLocalizations.of(context).categoryName, controller: _name, autofocus: true, onSubmitted: (_) => _save()),
          const SizedBox(height: Space.xl),
          FormActions(onSave: _save, saving: _saving, failure: _failure),
        ],
      );
}
