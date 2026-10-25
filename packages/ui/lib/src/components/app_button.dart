import 'package:flutter/material.dart';

import '../tokens/spacing.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive }

/// One button for every variant. [large] gives the 56dp primary-action height
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
    final scheme = Theme.of(context).colorScheme;
    final height = large ? TapSize.primary : TapSize.min;
    final minSize = Size(expand ? double.infinity : TapSize.min, height);
    final callback = loading ? null : onPressed;

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: _spinnerColor(scheme)),
          )
        else if (icon != null)
          Icon(icon, size: 20),
        if (loading || icon != null) const SizedBox(width: Space.sm),
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );

    final semantic = Semantics(button: true, enabled: callback != null, child: child);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: callback,
          style: FilledButton.styleFrom(minimumSize: minSize),
          child: semantic,
        ),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: callback,
          style: FilledButton.styleFrom(
            minimumSize: minSize,
            backgroundColor: scheme.secondaryContainer,
            foregroundColor: scheme.onSecondaryContainer,
          ),
          child: semantic,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: callback,
          style: OutlinedButton.styleFrom(minimumSize: minSize),
          child: semantic,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(minimumSize: minSize),
          child: semantic,
        ),
      AppButtonVariant.destructive => FilledButton(
          onPressed: callback,
          style: FilledButton.styleFrom(
            minimumSize: minSize,
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          child: semantic,
        ),
    };
  }

  Color _spinnerColor(ColorScheme scheme) => switch (variant) {
        AppButtonVariant.primary => scheme.onPrimary,
        AppButtonVariant.destructive => scheme.onError,
        _ => scheme.onSurface,
      };
}
