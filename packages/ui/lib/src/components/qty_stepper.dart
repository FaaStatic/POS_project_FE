import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

import '../../l10n/ui_localizations.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

/// Whole numbers for pieces; otherwise digits with one comma or dot and at most three
/// decimals, the most the backend keeps (`numeric(12,3)`).
List<TextInputFormatter> qtyInputFormatters({required bool fraction}) => [
  if (fraction)
    TextInputFormatter.withFunction((old, next) {
      final m = RegExp(r'^(\d*[.,]?)(\d*)$').firstMatch(next.text);
      if (m == null) return old;
      final text = '${m[1]}${m[2]!.length > 3 ? m[2]!.substring(0, 3) : m[2]}';
      return text == next.text ? next : TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    })
  else
    FilteringTextInputFormatter.digitsOnly,
];

/// 1 → "1", 0.25 → "0,25", 1.2500000000000002 → "1,25".
String qtyText(double value) {
  final rounded = (value * 1000).roundToDouble() / 1000;
  if (rounded == rounded.roundToDouble()) return '${rounded.round()}';
  return rounded.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceAll('.', ',');
}

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

  String get _label => qtyText(value);

  /// ± 1 from the typed value, so 0,25 steps to 1,25; kept at three decimals like the backend.
  double _stepped(double delta) => max(0, (value + delta) * 1000).roundToDouble() / 1000;

  Future<void> _edit(BuildContext context) async {
    final result = await showShadDialog<double>(
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
    final square = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.small + 2));
    // 32dp squares drawn, 48dp hit area kept by the padded tap target size. Material
    // IconButton stays here because a shadcn icon button has no padded hit area.
    const drawn = Size.square(32);
    // Muted minus, filled plus: the frequent action carries the weight.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: l10n.decrease,
          style: IconButton.styleFrom(
            shape: square,
            minimumSize: drawn,
            fixedSize: drawn,
            padding: EdgeInsets.zero,
            backgroundColor: scheme.surfaceContainer,
            foregroundColor: scheme.onSurface,
          ),
          onPressed: enabled ? () => onChanged(_stepped(-1)) : null,
          icon: const Icon(Icons.remove_rounded, size: 20),
        ),
        Semantics(
          label: l10n.qtyFor(itemName),
          value: _label,
          button: enabled,
          child: InkWell(
            onTap: enabled ? () => _edit(context) : null,
            borderRadius: BorderRadius.circular(Radii.small),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 36, minHeight: 48),
              child: Center(child: Text(_label, style: theme.textTheme.titleMedium?.tabular)),
            ),
          ),
        ),
        IconButton.filled(
          tooltip: l10n.increase,
          style: IconButton.styleFrom(shape: square, minimumSize: drawn, fixedSize: drawn, padding: EdgeInsets.zero),
          onPressed: enabled ? () => onChanged(_stepped(1)) : null,
          icon: const Icon(Icons.add_rounded, size: 20),
        ),
      ],
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
    return ShadDialog(
      title: Text(l10n.qtyFor(widget.itemName)),
      actions: [
        AppButton(label: l10n.cancel, variant: AppButtonVariant.outline, onPressed: () => Navigator.pop(context)),
        AppButton(label: 'OK', onPressed: _submit),
      ],
      child: ShadInputFormField(
        controller: _controller,
        autofocus: true,
        label: Text(l10n.quantity),
        keyboardType: TextInputType.numberWithOptions(decimal: widget.allowFraction),
        inputFormatters: qtyInputFormatters(fraction: widget.allowFraction),
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}
