import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';
import 'failure_text.dart';
import 'paged_list_cubit.dart';

class RowAction {
  const RowAction(this.label, this.onPressed, {this.destructive = false});
  final String label;
  final VoidCallback? onPressed;
  final bool destructive;
}

/// Visible "Aksi" button that opens the row's actions; keyboard reachable.
class ActionsMenu extends StatelessWidget {
  const ActionsMenu({super.key, required this.actions});
  final List<RowAction> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MenuAnchor(
      menuChildren: [
        for (final a in actions)
          MenuItemButton(
            onPressed: a.onPressed,
            child: Text(a.label, style: a.destructive ? TextStyle(color: scheme.error) : null),
          ),
      ],
      builder: (context, controller, _) => AppButton(
        label: AppLocalizations.of(context).actions,
        icon: Iconsax.more_copy,
        variant: AppButtonVariant.outline,
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// Loading, error, empty, and data states for a paged list.
class PagedBody<T> extends StatelessWidget {
  const PagedBody({
    super.key,
    required this.state,
    required this.emptyMessage,
    required this.onRetry,
    required this.builder,
    this.emptyAction,
    this.onEmptyAction,
  });

  final PagedState<T> state;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget Function(List<T> items) builder;
  final String? emptyAction;
  final VoidCallback? onEmptyAction;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.items.isEmpty) return const LoadingView();
    if (state.failure != null && state.items.isEmpty) {
      return ErrorState(
        message: AppLocalizations.of(context).loadFailed(failureText(context, state.failure!)),
        onRetry: onRetry,
      );
    }
    if (state.items.isEmpty) return EmptyState(message: emptyMessage, actionLabel: emptyAction, onAction: onEmptyAction);
    return builder(state.items);
  }
}

/// Page header row: filters on the left, primary actions as a labelled row (quick access, not an icon grid).
class FilterBar extends StatelessWidget {
  const FilterBar({super.key, required this.children});
  final List<Widget> children;

  // Capped at 40% of the screen and scrollable, so on a phone at large text the list below keeps room.
  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.sm),
          child: Wrap(spacing: Space.md, runSpacing: Space.md, crossAxisAlignment: WrapCrossAlignment.center, children: children),
        ),
      );
}

/// Permanent delete confirmation: the admin types the exact name.
Future<String?> showTypeToConfirm(BuildContext context, {required String name, required String hint}) {
  final l10n = AppLocalizations.of(context);
  return showShadDialog<String>(context: context, builder: (_) => _TypeToConfirm(name: name, hint: hint, l10n: l10n));
}

class _TypeToConfirm extends StatefulWidget {
  const _TypeToConfirm({required this.name, required this.hint, required this.l10n});
  final String name;
  final String hint;
  final AppLocalizations l10n;

  @override
  State<_TypeToConfirm> createState() => _TypeToConfirmState();
}

class _TypeToConfirmState extends State<_TypeToConfirm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShadDialog.alert(
      title: Text(l10n.purgeTitle(widget.name)),
      description: Text(widget.hint),
      actions: [
        AppButton(label: l10n.cancel, variant: AppButtonVariant.outline, onPressed: () => Navigator.pop(context)),
        AppButton(
          label: l10n.purge,
          variant: AppButtonVariant.destructive,
          onPressed: _controller.text.trim() == widget.name ? () => Navigator.pop(context, _controller.text.trim()) : null,
        ),
      ],
      child: AppTextField(
        label: l10n.purgeTypeName(widget.name),
        controller: _controller,
        autofocus: true,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

/// Submit row for forms shown through [showFormSurface].
class FormActions extends StatelessWidget {
  const FormActions({super.key, required this.onSave, this.saving = false, this.failure});
  final VoidCallback onSave;
  final bool saving;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (failure != null) ...[
          Semantics(
            liveRegion: true,
            child: Text(failureText(context, failure!), style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          const SizedBox(height: Space.md),
        ],
        Wrap(
          alignment: WrapAlignment.end,
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            AppButton(label: l10n.cancel, variant: AppButtonVariant.ghost, onPressed: () => Navigator.pop(context)),
            AppButton(label: l10n.save, loading: saving, onPressed: onSave),
          ],
        ),
      ],
    );
  }
}

String dateText(BuildContext context, DateTime? d) =>
    d == null ? '-' : formatDate(d, locale: Localizations.localeOf(context).languageCode);

String dateTimeText(BuildContext context, DateTime? d) =>
    d == null ? '-' : formatDateTime(d, locale: Localizations.localeOf(context).languageCode);

String money(BuildContext context, num v) => formatRupiah(v, locale: Localizations.localeOf(context).languageCode);
