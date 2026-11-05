import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/app_theme.dart';

/// A row action drawn as an icon alone. The [tooltip] is also its accessible name, since the
/// icon carries no text.
class IconAction extends StatelessWidget {
  const IconAction({super.key, required this.icon, required this.tooltip, required this.onPressed, this.destructive = false});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  /// Tints the icon with the error color, for actions that cannot be undone.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes.of(context);
    return Tooltip(
      message: tooltip,
      child: ShadIconButton.ghost(
        width: sizes.control,
        height: sizes.control,
        onPressed: onPressed,
        icon: Icon(icon, size: sizes.compact ? 18.0 : 22.0, color: destructive ? Theme.of(context).colorScheme.error : null),
      ),
    );
  }
}
