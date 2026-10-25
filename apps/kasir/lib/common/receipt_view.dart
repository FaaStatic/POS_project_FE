import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// On-screen copy of the printed receipt. Monospace keeps the columns aligned
/// exactly as they come out of the thermal printer.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.document});

  final ReceiptDocument document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium!.copyWith(fontFamily: 'monospace', package: null, height: 1.35);
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Radii.medium),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in document.lines)
              Text(
                line.align == ReceiptAlign.center ? _center(line.text, document) : line.text,
                style: line.bold ? base.copyWith(fontWeight: FontWeight.w700) : base,
                softWrap: false,
              ),
          ],
        ),
      ),
    );
  }

  static String _center(String text, ReceiptDocument doc) {
    final width = doc.lines.map((l) => l.text.length).fold(0, (a, b) => a > b ? a : b);
    final pad = (width - text.length) ~/ 2;
    return pad > 0 ? '${' ' * pad}$text' : text;
  }
}
