import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// A titled group of fields; a hairline closes it unless it is [last].
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children, this.last = false});
  final String title;
  final List<Widget> children;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(title, style: theme.textTheme.titleSmall)),
        const SizedBox(height: Space.md),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: Space.lg, children: children),
        if (!last) ...[
          const SizedBox(height: Space.lg),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: Space.lg),
        ],
      ],
    );
  }
}

/// Related fields side by side. Each needs [minWidth]; when they do not all fit they stack,
/// or with [wrap] fill rows of as many as fit. At large text they always stack.
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.children, this.minWidth = 220, this.flex, this.wrap = false});
  final List<Widget> children;
  final double minWidth;

  /// Relative widths, used only when every field shares one row.
  final List<int>? flex;
  final bool wrap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) {
          final n = children.length;
          final fit = ((c.maxWidth + Space.lg) / (minWidth + Space.lg)).floor();
          final big = MediaQuery.textScalerOf(context).scale(1) > 1.3;
          var cols = big ? 1 : (wrap ? fit.clamp(1, n) : (fit >= n ? n : 1));
          // Wrapping 4 fields as 3 + 1 strands the last one; narrow the rows until none is alone.
          while (wrap && cols > 2 && n % cols == 1) {
            cols--;
          }
          if (cols == 1) {
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: Space.lg, children: children);
          }
          final rows = [
            for (var i = 0; i < n; i += cols)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Space.lg,
                children: [
                  for (var j = 0; j < cols; j++)
                    Expanded(
                      flex: cols == n ? (flex?[j] ?? 1) : 1,
                      child: i + j < n ? children[i + j] : const SizedBox.shrink(),
                    ),
                ],
              ),
          ];
          return rows.length == 1
              ? rows.single
              : Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: Space.lg, children: rows);
        },
      );
}
