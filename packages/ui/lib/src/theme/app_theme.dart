import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'chart_colors.dart';
import 'shell_colors.dart';
import 'status_colors.dart';

abstract final class AppTheme {
  static final light = _build(
    const ColorScheme(
      brightness: Brightness.light,
      // shadcn: actions are ink; green is kept for meaning (StatusColors).
      primary: Zinc.c900,
      onPrimary: Colors.white,
      primaryContainer: Zinc.c100,
      onPrimaryContainer: Zinc.c900,
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
      surfaceContainer: Zinc.c100,
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
    ChartColors.light,
    ShellColors.light,
  );

  static final dark = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: Zinc.c50,
      onPrimary: Zinc.c900,
      primaryContainer: Zinc.c800,
      onPrimaryContainer: Zinc.c50,
      secondary: Zinc.c50,
      onSecondary: Zinc.c900,
      secondaryContainer: Zinc.c800,
      onSecondaryContainer: Zinc.c50,
      error: BrandColors.redDark,
      onError: Color(0xFF450A0A),
      errorContainer: BrandColors.redContainerDark,
      onErrorContainer: Color(0xFFFEE2E2),
      surface: BrandColors.surfaceDark,
      onSurface: Zinc.c50,
      onSurfaceVariant: Zinc.c400,
      surfaceContainerLowest: BrandColors.canvasDark,
      surfaceContainerLow: BrandColors.surfaceDarkHigh,
      surfaceContainer: BrandColors.surfaceDarkHigh,
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
    ChartColors.dark,
    ShellColors.dark,
  );

  static ThemeData _build(ColorScheme scheme, StatusColors status, ChartColors chart, ShellColors shell) {
    final text = buildTextTheme(scheme.onSurface, scheme.onSurfaceVariant);
    final control = BorderRadius.circular(Radii.control);
    final medium = BorderRadius.circular(Radii.medium);
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(borderRadius: control, borderSide: BorderSide(color: color, width: width));
    const buttonSize = Size(TapSize.min, TapSize.min);
    final buttonShape = RoundedRectangleBorder(borderRadius: control);
    const buttonPadding = EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      package: fontPackage,
      textTheme: text,
      scaffoldBackgroundColor: shell.canvas,
      canvasColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [status, chart, shell],
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: shell.canvas,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.headlineSmall,
      ),
      // White cards sit flat on the zinc canvas; the tone step is the only depth cue.
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: medium),
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
          backgroundColor: scheme.surface,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
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
        backgroundColor: shell.background,
        contentTextStyle: text.bodyMedium?.copyWith(color: shell.foreground),
        actionTextColor: shell.indicator,
        shape: RoundedRectangleBorder(borderRadius: medium),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        labelStyle: text.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: shell.background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 72,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: s.contains(WidgetState.selected) ? shell.foreground : shell.muted),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => text.labelSmall?.copyWith(color: s.contains(WidgetState.selected) ? shell.foreground : shell.muted),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.surfaceContainer,
        selectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurface),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.surfaceContainer,
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStatePropertyAll(text.labelLarge),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: Space.md,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodySmall,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: text.labelLarge,
        unselectedLabelStyle: text.labelLarge,
        dividerColor: scheme.outlineVariant,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      // Indonesian range labels overflow the default headline on phone widths.
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        headerHeadlineStyle: text.headlineSmall,
        rangePickerHeaderHeadlineStyle: text.titleSmall,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: control, side: BorderSide(color: scheme.outlineVariant)),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: control, side: BorderSide(color: scheme.outlineVariant)),
        textStyle: text.bodyMedium,
      ),
    );
  }
}
