import 'package:flutter/material.dart';

import '../theme/status_colors.dart';
import '../tokens/spacing.dart';

enum BadgeTone { neutral, success, warning, danger }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.tone = BadgeTone.neutral, this.icon});

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = StatusColors.of(context);
    final (bg, fg) = switch (tone) {
      BadgeTone.neutral => (scheme.surfaceContainerHigh, scheme.onSurface),
      BadgeTone.success => (status.successContainer, scheme.onSurface),
      BadgeTone.warning => (status.warningContainer, scheme.onSurface),
      BadgeTone.danger => (status.dangerContainer, scheme.onSurface),
    };
    final dot = switch (tone) {
      BadgeTone.neutral => scheme.onSurfaceVariant,
      BadgeTone.success => status.success,
      BadgeTone.warning => status.warning,
      BadgeTone.danger => status.danger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.small)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon != null
              ? Icon(icon, size: 16, color: dot)
              : Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: Space.xs + 2),
          Flexible(
            child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }
}
