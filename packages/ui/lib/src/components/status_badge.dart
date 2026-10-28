import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/status_colors.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

enum BadgeTone { neutral, success, warning, danger }

/// Pill status label: tinted fill, deeper text of the same hue (6:1 or better).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.tone = BadgeTone.neutral, this.icon});

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = StatusColors.of(context);
    final dark = theme.brightness == Brightness.dark;
    final (bg, fg) = switch (tone) {
      BadgeTone.neutral => (scheme.surfaceContainerHigh, scheme.onSurface),
      BadgeTone.success => (status.successContainer, dark ? Mint.c200 : Mint.c800),
      BadgeTone.warning => (status.warningContainer, dark ? BrandColors.amberDark : const Color(0xFF92400E)),
      BadgeTone.danger => (status.dangerContainer, dark ? BrandColors.redDark : const Color(0xFF7F1D1D)),
    };
    return ShadBadge(
      backgroundColor: bg,
      hoverBackgroundColor: bg,
      foregroundColor: fg,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: Space.sm + 2, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: Space.xs)],
          Flexible(child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: fg))),
        ],
      ),
    );
  }
}
