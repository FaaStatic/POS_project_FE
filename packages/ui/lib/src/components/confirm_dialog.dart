import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
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
