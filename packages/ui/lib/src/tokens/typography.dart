import 'package:flutter/material.dart';

const fontFamily = 'Inter';
const fontPackage = 'ui';

/// [compact] is the pointer-driven CMS scale (14px body, as shadcn on the web);
/// the touch scale keeps a 16px body for the kasir at arm's length.
TextTheme buildTextTheme(Color onSurface, Color muted, {bool compact = false}) {
  TextStyle s(double size, FontWeight weight, double height, [Color? color]) => TextStyle(
        fontFamily: fontFamily,
        package: fontPackage,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? onSurface,
      );
  if (compact) {
    return TextTheme(
      displaySmall: s(30, FontWeight.w700, 1.2),
      headlineMedium: s(24, FontWeight.w700, 1.25),
      headlineSmall: s(20, FontWeight.w600, 1.3),
      titleLarge: s(18, FontWeight.w600, 1.35),
      titleMedium: s(16, FontWeight.w600, 1.4),
      titleSmall: s(14, FontWeight.w600, 1.4),
      bodyLarge: s(15, FontWeight.w400, 1.5),
      bodyMedium: s(14, FontWeight.w400, 1.5),
      bodySmall: s(13, FontWeight.w400, 1.45, muted),
      labelLarge: s(14, FontWeight.w600, 1.3),
      labelMedium: s(13, FontWeight.w500, 1.3),
      labelSmall: s(12, FontWeight.w500, 1.3, muted),
    );
  }
  return TextTheme(
    displaySmall: s(36, FontWeight.w700, 1.15),
    headlineMedium: s(28, FontWeight.w700, 1.2),
    headlineSmall: s(24, FontWeight.w600, 1.25),
    titleLarge: s(20, FontWeight.w600, 1.3),
    titleMedium: s(18, FontWeight.w600, 1.35),
    titleSmall: s(16, FontWeight.w600, 1.4),
    bodyLarge: s(16, FontWeight.w400, 1.5),
    bodyMedium: s(16, FontWeight.w400, 1.5),
    bodySmall: s(14, FontWeight.w400, 1.45, muted),
    labelLarge: s(16, FontWeight.w600, 1.25),
    labelMedium: s(14, FontWeight.w500, 1.3),
    labelSmall: s(13, FontWeight.w500, 1.3, muted),
  );
}

/// Tabular figures keep price columns aligned.
extension NumericText on TextStyle {
  TextStyle get tabular => copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
