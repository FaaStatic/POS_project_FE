import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/ui_localizations.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// − qty + with 48dp targets. Tapping the number opens a numeric keypad for
/// large or fractional quantities (kg, liter).
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    required this.itemName,
    this.enabled = true,
    this.allowFraction = false,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String itemName;
  final bool enabled;
  final bool allowFraction;

  String get _label => value == value.roundToDouble() ? '${value.round()}' : '$value'.replaceAll('.', ',');

  Future<void> _edit(BuildContext context) async {
    final result = await showDialog<double>(
      context: context,
      builder: (_) => _QtyDialog(initial: _label, itemName: itemName, allowFraction: allowFraction),
    );
    if (result != null && result >= 0) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(Radii.full)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.decrease,
            onPressed: enabled ? () => onChanged(value - 1 < 0 ? 0 : value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          Semantics(
            label: l10n.qtyFor(itemName),
            value: _label,
            button: enabled,
            child: InkWell(
              onTap: enabled ? () => _edit(context) : null,
              borderRadius: BorderRadius.circular(Radii.small),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
                child: Center(child: Text(_label, style: theme.textTheme.titleMedium?.tabular)),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.increase,
            onPressed: enabled ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _QtyDialog extends StatefulWidget {
  const _QtyDialog({required this.initial, required this.itemName, required this.allowFraction});
  final String initial;
  final String itemName;
  final bool allowFraction;

  @override
  State<_QtyDialog> createState() => _QtyDialogState();
}

class _QtyDialogState extends State<_QtyDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, double.tryParse(_controller.text.replaceAll(',', '.')));

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.qtyFor(widget.itemName)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.allowFraction),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(widget.allowFraction ? r'[0-9.,]' : r'[0-9]'))],
        decoration: InputDecoration(labelText: l10n.quantity),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }
}
