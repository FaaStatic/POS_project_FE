import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Navigation surfaces (CMS sidebar, kasir bar) and the one solid mint panel
/// per screen (kasir total, CMS login aside).
@immutable
class ShellColors extends ThemeExtension<ShellColors> {
  const ShellColors({
    required this.canvas,
    required this.nav,
    required this.onNav,
    required this.onNavMuted,
    required this.navSelected,
    required this.onNavSelected,
    required this.border,
    required this.brand,
    required this.onBrand,
    required this.onBrandMuted,
  });

  /// Page background behind cards.
  final Color canvas;
  final Color nav;
  final Color onNav;
  final Color onNavMuted;
  final Color navSelected;
  final Color onNavSelected;
  final Color border;
  final Color brand;
  final Color onBrand;
  final Color onBrandMuted;

  static const light = ShellColors(
    canvas: Neutral.canvas,
    nav: Colors.white,
    onNav: Neutral.foreground,
    onNavMuted: Neutral.muted,
    navSelected: Mint.c100,
    onNavSelected: Mint.c800,
    border: Neutral.border,
    brand: Mint.c800,
    onBrand: Colors.white,
    onBrandMuted: Mint.c100,
  );

  static const dark = ShellColors(
    canvas: Neutral.canvasDark,
    nav: Neutral.surfaceDark,
    onNav: Neutral.foregroundDark,
    onNavMuted: Neutral.mutedDark,
    navSelected: Mint.c900,
    onNavSelected: Mint.c200,
    border: Neutral.borderDark,
    brand: Mint.c900,
    onBrand: Colors.white,
    onBrandMuted: Mint.c200,
  );

  static ShellColors of(BuildContext context) => Theme.of(context).extension<ShellColors>()!;

  @override
  ShellColors copyWith({
    Color? canvas,
    Color? nav,
    Color? onNav,
    Color? onNavMuted,
    Color? navSelected,
    Color? onNavSelected,
    Color? border,
    Color? brand,
    Color? onBrand,
    Color? onBrandMuted,
  }) =>
      ShellColors(
        canvas: canvas ?? this.canvas,
        nav: nav ?? this.nav,
        onNav: onNav ?? this.onNav,
        onNavMuted: onNavMuted ?? this.onNavMuted,
        navSelected: navSelected ?? this.navSelected,
        onNavSelected: onNavSelected ?? this.onNavSelected,
        border: border ?? this.border,
        brand: brand ?? this.brand,
        onBrand: onBrand ?? this.onBrand,
        onBrandMuted: onBrandMuted ?? this.onBrandMuted,
      );

  @override
  ShellColors lerp(ShellColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return ShellColors(
      canvas: l(canvas, other.canvas),
      nav: l(nav, other.nav),
      onNav: l(onNav, other.onNav),
      onNavMuted: l(onNavMuted, other.onNavMuted),
      navSelected: l(navSelected, other.navSelected),
      onNavSelected: l(onNavSelected, other.onNavSelected),
      border: l(border, other.border),
      brand: l(brand, other.brand),
      onBrand: l(onBrand, other.onBrand),
      onBrandMuted: l(onBrandMuted, other.onBrandMuted),
    );
  }
}
