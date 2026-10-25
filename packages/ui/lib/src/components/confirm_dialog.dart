import 'package:flutter/material.dart';

import '../../l10n/ui_localizations.dart';

/// Decision dialog for actions that must interrupt the flow (close a tab, cancel a sale).
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(UiLocalizations.of(context).cancel)),
        FilledButton(
          style: destructive ? FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError) : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
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
    showDialog<String>(
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _form,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          maxLength: 500,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(labelText: widget.label),
          validator: (v) => (v?.trim().length ?? 0) < 3 ? widget.tooShort : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(UiLocalizations.of(context).cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError),
          onPressed: () {
            if (_form.currentState!.validate()) Navigator.pop(context, _controller.text.trim());
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
