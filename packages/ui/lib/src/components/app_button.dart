import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/app_theme.dart';

/// [destructiveGhost] is a red text action in a row (Hapus, Cabut) without a fill.
enum AppButtonVariant { primary, secondary, outline, ghost, destructive, destructiveGhost }

/// One shadcn button for every variant. [large] gives the primary-action height
/// (Bayar, Simpan). While [loading] the button keeps its width and ignores taps.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.large = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool large;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes.of(context);
    final theme = Theme.of(context);
    final iconSize = sizes.compact ? 16.0 : 20.0;
    final leading = loading
        ? SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: _spinnerColor(theme.colorScheme)),
          )
        : icon == null
            ? null
            : Icon(icon, size: iconSize);
    final textStyle = sizes.compact ? theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500) : theme.textTheme.labelLarge;
    final padding = EdgeInsets.symmetric(horizontal: large ? 24 : 16, vertical: 8);
    final enabled = onPressed != null || loading;
    final callback = loading ? null : onPressed;
    final child = Flexible(child: Text(label, textAlign: TextAlign.center));

    // height: 0 lets the button grow with 200% text; the box below keeps the minimum.
    final button = switch (variant) {
      AppButtonVariant.primary => ShadButton(
          onPressed: callback, enabled: enabled, leading: leading, height: 0, padding: padding, textStyle: textStyle, child: child),
      AppButtonVariant.secondary => ShadButton.secondary(
          onPressed: callback, enabled: enabled, leading: leading, height: 0, padding: padding, textStyle: textStyle, child: child),
      AppButtonVariant.outline => ShadButton.outline(
          onPressed: callback, enabled: enabled, leading: leading, height: 0, padding: padding, textStyle: textStyle, child: child),
      AppButtonVariant.ghost => ShadButton.ghost(
          onPressed: callback, enabled: enabled, leading: leading, height: 0, padding: padding, textStyle: textStyle, child: child),
      AppButtonVariant.destructive => ShadButton.destructive(
          onPressed: callback, enabled: enabled, leading: leading, height: 0, padding: padding, textStyle: textStyle, child: child),
      AppButtonVariant.destructiveGhost => ShadButton.ghost(
          onPressed: callback,
          enabled: enabled,
          leading: leading,
          height: 0,
          padding: padding,
          textStyle: textStyle,
          foregroundColor: theme.colorScheme.error,
          hoverForegroundColor: theme.colorScheme.error,
          child: child),
    };

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: large ? sizes.primary : sizes.control,
        minWidth: expand ? double.infinity : sizes.control,
      ),
      child: button,
    );
  }

  Color _spinnerColor(ColorScheme scheme) => switch (variant) {
        AppButtonVariant.primary => scheme.onPrimary,
        AppButtonVariant.destructive => scheme.onError,
        AppButtonVariant.destructiveGhost => scheme.error,
        _ => scheme.onSurface,
      };
}
