import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Colors for the ink navigation surfaces (CMS sidebar/rail, kasir nav).
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
    required this.selected,
  });

  final Color background;
  final Color raised;
  final Color foreground;
  final Color muted;
  final Color indicator;
  final Color onIndicator;

  /// Page background behind cards.
  final Color canvas;

  /// Selected navigation item on the ink surface (white text on it).
  final Color selected;

  static const light = ShellColors(
    background: BrandColors.ink,
    raised: BrandColors.inkRaised,
    foreground: Colors.white,
    muted: Zinc.c400,
    indicator: BrandColors.greenOnInk,
    onIndicator: BrandColors.onGreenDark,
    canvas: BrandColors.canvas,
    selected: BrandColors.inkRaised,
  );

  static const dark = ShellColors(
    background: Zinc.c900,
    raised: Zinc.c800,
    foreground: Zinc.c50,
    muted: Zinc.c400,
    indicator: BrandColors.greenOnInk,
    onIndicator: BrandColors.onGreenDark,
    canvas: BrandColors.canvasDark,
    selected: Zinc.c800,
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
    Color? selected,
  }) =>
      ShellColors(
        background: background ?? this.background,
        raised: raised ?? this.raised,
        foreground: foreground ?? this.foreground,
        muted: muted ?? this.muted,
        indicator: indicator ?? this.indicator,
        onIndicator: onIndicator ?? this.onIndicator,
        canvas: canvas ?? this.canvas,
        selected: selected ?? this.selected,
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
      selected: l(selected, other.selected),
    );
  }
}
