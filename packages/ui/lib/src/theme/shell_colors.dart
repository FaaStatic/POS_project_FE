import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Colors for the branded navigation surfaces (CMS sidebar/rail, kasir header).
@immutable
class ShellColors extends ThemeExtension<ShellColors> {
  const ShellColors({
    required this.background,
    required this.raised,
    required this.foreground,
    required this.muted,
    required this.indicator,
    required this.onIndicator,
    required this.canvas,
  });

  final Color background;
  final Color raised;
  final Color foreground;
  final Color muted;
  final Color indicator;
  final Color onIndicator;

  /// Page background behind cards.
  final Color canvas;

  static const light = ShellColors(
    background: BrandColors.forest,
    raised: BrandColors.forestRaised,
    foreground: Colors.white,
    muted: BrandColors.onForestMuted,
    indicator: BrandColors.indicatorOnForest,
    onIndicator: BrandColors.forest,
    canvas: BrandColors.mintCanvas,
  );

  static const dark = ShellColors(
    background: BrandColors.forestDark,
    raised: BrandColors.forest,
    foreground: Color(0xFFF4F4F5),
    muted: BrandColors.onForestMutedDark,
    indicator: BrandColors.indicatorOnForestDark,
    onIndicator: BrandColors.onGreenDark,
    canvas: BrandColors.canvasDark,
  );

  static ShellColors of(BuildContext context) => Theme.of(context).extension<ShellColors>()!;

  @override
  ShellColors copyWith({
    Color? background,
    Color? raised,
    Color? foreground,
    Color? muted,
    Color? indicator,
    Color? onIndicator,
    Color? canvas,
  }) =>
      ShellColors(
        background: background ?? this.background,
        raised: raised ?? this.raised,
        foreground: foreground ?? this.foreground,
        muted: muted ?? this.muted,
        indicator: indicator ?? this.indicator,
        onIndicator: onIndicator ?? this.onIndicator,
        canvas: canvas ?? this.canvas,
      );

  @override
  ShellColors lerp(ShellColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return ShellColors(
      background: l(background, other.background),
      raised: l(raised, other.raised),
      foreground: l(foreground, other.foreground),
      muted: l(muted, other.muted),
      indicator: l(indicator, other.indicator),
      onIndicator: l(onIndicator, other.onIndicator),
      canvas: l(canvas, other.canvas),
    );
  }
}
