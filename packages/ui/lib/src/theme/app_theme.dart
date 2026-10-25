import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'status_colors.dart';

abstract final class AppTheme {
  static final light = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: BrandColors.greenLight,
      onPrimary: Colors.white,
      primaryContainer: BrandColors.greenContainerLight,
      onPrimaryContainer: Color(0xFF14532D),
      secondary: Zinc.c900,
      onSecondary: Zinc.c50,
      secondaryContainer: Zinc.c100,
      onSecondaryContainer: Zinc.c900,
      error: BrandColors.redLight,
      onError: Colors.white,
      errorContainer: BrandColors.redContainerLight,
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Colors.white,
      onSurface: Zinc.c950,
      onSurfaceVariant: Zinc.c600,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Zinc.c50,
      surfaceContainer: Zinc.c50,
      surfaceContainerHigh: Zinc.c100,
      surfaceContainerHighest: Zinc.c200,
      // Input borders need 3:1 against the surface (WCAG 1.4.11), dividers do not.
      outline: Zinc.c500,
      outlineVariant: Zinc.c200,
      inverseSurface: Zinc.c900,
      onInverseSurface: Zinc.c50,
      inversePrimary: BrandColors.greenDark,
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    StatusColors.light,
  );

  static final dark = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: BrandColors.greenDark,
      onPrimary: BrandColors.onGreenDark,
      primaryContainer: BrandColors.greenContainerDark,
      onPrimaryContainer: Color(0xFFDCFCE7),
      secondary: Zinc.c50,
      onSecondary: Zinc.c900,
      secondaryContainer: Zinc.c800,
      onSecondaryContainer: Zinc.c50,
      error: BrandColors.redDark,
      onError: Color(0xFF450A0A),
      errorContainer: BrandColors.redContainerDark,
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Zinc.c950,
      onSurface: Zinc.c50,
      onSurfaceVariant: Zinc.c400,
      surfaceContainerLowest: Zinc.c950,
      surfaceContainerLow: Zinc.c900,
      surfaceContainer: Zinc.c900,
      surfaceContainerHigh: Zinc.c800,
      surfaceContainerHighest: Zinc.c700,
      outline: Zinc.c500,
      outlineVariant: Zinc.c800,
      inverseSurface: Zinc.c50,
      onInverseSurface: Zinc.c900,
      inversePrimary: BrandColors.greenLight,
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    StatusColors.dark,
  );

  static ThemeData _build(ColorScheme scheme, StatusColors status) {
    final text = buildTextTheme(scheme.onSurface, scheme.onSurfaceVariant);
    final small = BorderRadius.circular(Radii.small);
    final medium = BorderRadius.circular(Radii.medium);
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(borderRadius: small, borderSide: BorderSide(color: color, width: width));
    const buttonSize = Size(TapSize.min, TapSize.min);
    final buttonShape = RoundedRectangleBorder(borderRadius: small);
    const buttonPadding = EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      package: fontPackage,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [status],
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: medium, side: BorderSide(color: scheme.outlineVariant)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          foregroundColor: scheme.onSurface,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: buttonSize, shape: buttonShape),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.md),
        border: border(scheme.outline),
        enabledBorder: border(scheme.outline),
        focusedBorder: border(scheme.primary, 2),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 2),
        disabledBorder: border(scheme.outlineVariant),
        labelStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: scheme.onSurface),
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        errorMaxLines: 3,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: medium),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.medium)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(borderRadius: small),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: small),
        side: BorderSide(color: scheme.outline),
        labelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.sm),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        selectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurface),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(borderRadius: small),
        labelTextStyle: WidgetStatePropertyAll(text.labelLarge),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: Space.md,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodySmall,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: text.labelLarge,
        unselectedLabelStyle: text.labelLarge,
        dividerColor: scheme.outlineVariant,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: small, side: BorderSide(color: scheme.outlineVariant)),
        textStyle: text.bodyMedium,
      ),
    );
  }
}
