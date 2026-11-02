import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/status_colors.dart';
import '../tokens/spacing.dart';
import 'app_button.dart';

/// Decision dialog for actions that must interrupt the flow (close a tab, cancel a sale).
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showShadDialog<bool>(
    context: context,
    builder: (context) => ShadDialog.alert(
      title: Text(title),
      description: message == null ? null : Text(message),
      actions: [
        AppButton(
          label: UiLocalizations.of(context).cancel,
          variant: AppButtonVariant.outline,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          label: confirmLabel,
          variant: destructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
  return result ?? false;
}

enum InfoKind { success, error, info }

/// Modal replacement for a snackbar: a tinted status icon, a short title and the
/// [message] below it, with a full-width close button. With [actionLabel] a primary
/// action sits above the close button; resolves true when it is chosen.
Future<bool> showInfoDialog(
  BuildContext context,
  String message, {
  required InfoKind kind,
  String? actionLabel,
}) async {
  final result = await showShadDialog<bool>(
    context: context,
    builder: (context) => _InfoDialog(message: message, kind: kind, actionLabel: actionLabel),
  );
  return result ?? false;
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({required this.message, required this.kind, this.actionLabel});
  final String message;
  final InfoKind kind;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final status = StatusColors.of(context);
    final (icon, fg, bg, title) = switch (kind) {
      InfoKind.success => (Iconsax.tick_circle_copy, status.success, status.successContainer, l10n.infoSuccess),
      InfoKind.error => (Iconsax.close_circle_copy, status.danger, status.dangerContainer, l10n.infoError),
      InfoKind.info => (Iconsax.info_circle_copy, scheme.onPrimaryContainer, scheme.primaryContainer, l10n.infoNotice),
    };
    return ShadDialog.alert(
      constraints: const BoxConstraints(maxWidth: 360),
      crossAxisAlignment: CrossAxisAlignment.center,
      titleTextAlign: TextAlign.center,
      descriptionTextAlign: TextAlign.center,
      actionsAxis: Axis.vertical,
      actionsVerticalDirection: VerticalDirection.down,
      actionsMainAxisSize: MainAxisSize.max,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: fg, size: 24),
          ),
          const SizedBox(height: Space.lg),
          Text(title),
        ],
      ),
      description: Text(message),
      actions: [
        if (actionLabel != null)
          AppButton(label: actionLabel!, expand: true, onPressed: () => Navigator.pop(context, true)),
        AppButton(
          label: l10n.close,
          expand: true,
          variant: actionLabel == null ? AppButtonVariant.primary : AppButtonVariant.outline,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}

/// Asks for a required reason (3–500 characters), e.g. to cancel a transaction.
Future<String?> showReasonDialog(
  BuildContext context, {
  required String title,
  required String label,
  required String confirmLabel,
  required String tooShort,
}) =>
    showShadDialog<String>(
      context: context,
      builder: (_) => _ReasonDialog(title: title, label: label, confirmLabel: confirmLabel, tooShort: tooShort),
    );

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({required this.title, required this.label, required this.confirmLabel, required this.tooShort});
  final String title;
  final String label;
  final String confirmLabel;
  final String tooShort;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _controller = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShadDialog.alert(
        title: Text(widget.title),
        actions: [
          AppButton(
            label: UiLocalizations.of(context).cancel,
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            label: widget.confirmLabel,
            variant: AppButtonVariant.destructive,
            onPressed: () {
              if (_form.currentState!.validate()) Navigator.pop(context, _controller.text.trim());
            },
          ),
        ],
        child: Form(
          key: _form,
          child: ShadInputFormField(
            controller: _controller,
            autofocus: true,
            maxLength: 500,
            maxLines: 3,
            minLines: 1,
            label: Text(widget.label),
            validator: (v) => v.trim().length < 3 ? widget.tooShort : null,
          ),
        ),
      );
}
