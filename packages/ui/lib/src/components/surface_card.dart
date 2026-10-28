import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/app_theme.dart';

/// White shadcn card on the canvas: the one container for grouped content.
/// [padding] defaults to the density's card padding.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding, this.color, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes.of(context);
    // ShadCard paints its fill with a DecoratedBox; a transparent Material above it
    // keeps ink from list tiles and taps visible.
    final ink = Material(type: MaterialType.transparency, child: child);
    if (onTap == null) return ShadCard(padding: padding, backgroundColor: color, child: ink);
    return ShadCard(
      padding: EdgeInsets.zero,
      backgroundColor: color,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(sizes.cardRadius),
          child: Padding(padding: padding ?? EdgeInsets.all(sizes.cardPadding), child: child),
        ),
      ),
    );
  }
}
