import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'chart_colors.dart';
import 'shell_colors.dart';
import 'status_colors.dart';

/// Control sizes for one density. The CMS is pointer-driven and dense; the kasir
/// is touched at arm's length, so its controls keep the 48dp target.
@immutable
class AppSizes extends ThemeExtension<AppSizes> {
  const AppSizes({
    required this.compact,
    required this.control,
    required this.primary,
    required this.controlRadius,
    required this.cardRadius,
    required this.cardPadding,
  });

  final bool compact;

  /// Buttons and inputs.
  final double control;

  /// The one large action on a screen (Bayar, Simpan).
  final double primary;
  final double controlRadius;
  final double cardRadius;
  final double cardPadding;

  static const dense = AppSizes(compact: true, control: 40, primary: 44, controlRadius: 8, cardRadius: 12, cardPadding: Space.xl);
  static const touch = AppSizes(
    compact: false,
    control: TapSize.min,
    primary: TapSize.primary,
    controlRadius: Radii.control,
    cardRadius: 20,
    cardPadding: Space.lg,
  );

  static AppSizes of(BuildContext context) => Theme.of(context).extension<AppSizes>() ?? touch;

  @override
  AppSizes copyWith({bool? compact, double? control, double? primary, double? controlRadius, double? cardRadius, double? cardPadding}) =>
      AppSizes(
        compact: compact ?? this.compact,
        control: control ?? this.control,
        primary: primary ?? this.primary,
        controlRadius: controlRadius ?? this.controlRadius,
        cardRadius: cardRadius ?? this.cardRadius,
        cardPadding: cardPadding ?? this.cardPadding,
      );

  // Density never animates; a theme switch keeps it.
  @override
  AppSizes lerp(AppSizes? other, double t) => this;
}

/// The Material theme and the matching shadcn theme for one density.
final class AppThemes {
  const AppThemes._(this.light, this.dark, this.shadLight, this.shadDark);
  final ThemeData light;
  final ThemeData dark;
  final ShadThemeData shadLight;
  final ShadThemeData shadDark;
}

abstract final class AppTheme {
  /// Kasir (phones and tablets).
  static final touch = _themes(AppSizes.touch);

  /// CMS (desktop web).
  static final compact = _themes(AppSizes.dense);

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: Mint.c700,
    onPrimary: Colors.white,
    primaryContainer: Mint.c100,
    onPrimaryContainer: Mint.c800,
    secondary: Mint.c800,
    onSecondary: Colors.white,
    secondaryContainer: Neutral.subtle,
    onSecondaryContainer: Neutral.foreground,
    error: BrandColors.redLight,
    onError: Colors.white,
    errorContainer: BrandColors.redContainerLight,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Colors.white,
    onSurface: Neutral.foreground,
    onSurfaceVariant: Neutral.muted,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8FAF9),
    surfaceContainer: Neutral.subtle,
    surfaceContainerHigh: Neutral.subtle,
    surfaceContainerHighest: Neutral.border,
    // Input borders need 3:1 against the surface (WCAG 1.4.11), dividers do not.
    outline: Neutral.input,
    outlineVariant: Neutral.border,
    inverseSurface: Neutral.foreground,
    onInverseSurface: Neutral.foregroundDark,
    inversePrimary: Mint.c400,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static const _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Mint.c400,
    onPrimary: Mint.c950,
    primaryContainer: Mint.c900,
    onPrimaryContainer: Mint.c200,
    secondary: Mint.c200,
    onSecondary: Mint.c950,
    secondaryContainer: Neutral.subtleDark,
    onSecondaryContainer: Neutral.foregroundDark,
    error: BrandColors.redDark,
    onError: Color(0xFF450A0A),
    errorContainer: BrandColors.redContainerDark,
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Neutral.surfaceDark,
    onSurface: Neutral.foregroundDark,
    onSurfaceVariant: Neutral.mutedDark,
    surfaceContainerLowest: Neutral.canvasDark,
    surfaceContainerLow: Neutral.subtleDark,
    surfaceContainer: Neutral.subtleDark,
    surfaceContainerHigh: Neutral.subtleDark,
    surfaceContainerHighest: Neutral.borderDark,
    outline: Neutral.inputDark,
    outlineVariant: Neutral.borderDark,
    inverseSurface: Neutral.foregroundDark,
    onInverseSurface: Neutral.foreground,
    inversePrimary: Mint.c700,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static AppThemes _themes(AppSizes sizes) {
    final light = _build(_light, StatusColors.light, ChartColors.light, ShellColors.light, sizes);
    final dark = _build(_dark, StatusColors.dark, ChartColors.dark, ShellColors.dark, sizes);
    return AppThemes._(light, dark, _shad(light, sizes), _shad(dark, sizes));
  }

  /// shadcn reads the same palette, so Material and shadcn widgets sit together.
  static ShadThemeData _shad(ThemeData material, AppSizes sizes) {
    final scheme = material.colorScheme;
    final shell = material.extension<ShellColors>()!;
    final text = material.textTheme;
    final radius = BorderRadius.circular(sizes.controlRadius);
    final inputPadding = (sizes.control - text.bodyMedium!.fontSize! * text.bodyMedium!.height!) / 2;
    ShadButtonSizeTheme size(double height, double horizontal) =>
        ShadButtonSizeTheme(height: height, padding: EdgeInsets.symmetric(horizontal: horizontal));

    return ShadThemeData(
      brightness: scheme.brightness,
      colorScheme: ShadColorScheme(
        background: scheme.surface,
        foreground: scheme.onSurface,
        card: scheme.surface,
        cardForeground: scheme.onSurface,
        popover: scheme.surface,
        popoverForeground: scheme.onSurface,
        primary: scheme.primary,
        primaryForeground: scheme.onPrimary,
        secondary: scheme.surfaceContainer,
        secondaryForeground: scheme.onSurface,
        muted: scheme.surfaceContainer,
        mutedForeground: scheme.onSurfaceVariant,
        accent: shell.navSelected,
        accentForeground: shell.onNavSelected,
        destructive: scheme.error,
        destructiveForeground: scheme.onError,
        border: scheme.outlineVariant,
        input: scheme.outline,
        ring: scheme.primary,
        selection: scheme.primaryContainer,
      ),
      radius: radius,
      textTheme: ShadTextTheme(family: fontFamily, package: fontPackage),
      disableSecondaryBorder: true,
      buttonSizesTheme: ShadButtonSizesTheme(
        regular: size(sizes.control, Space.lg),
        sm: size(sizes.compact ? 32 : 40, Space.md),
        lg: size(sizes.primary, Space.xl),
        icon: ShadButtonSizeTheme(height: sizes.control, width: sizes.control, padding: EdgeInsets.zero),
      ),
      inputTheme: ShadInputTheme(
        style: text.bodyMedium,
        placeholderStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        padding: EdgeInsets.symmetric(horizontal: Space.md, vertical: inputPadding),
        decoration: ShadDecoration(border: ShadBorder.all(width: 1, color: scheme.outline, radius: radius)),
      ),
      cardTheme: ShadCardTheme(
        backgroundColor: scheme.surface,
        radius: BorderRadius.circular(sizes.cardRadius),
        padding: EdgeInsets.all(sizes.cardPadding),
        // Dense dashboards separate panels with a hairline; kasir cards sit flat on the canvas.
        border: ShadBorder.all(width: 1, color: sizes.compact ? scheme.outlineVariant : Colors.transparent),
        shadows: const [],
      ),
    );
  }

  static ThemeData _build(ColorScheme scheme, StatusColors status, ChartColors chart, ShellColors shell, AppSizes sizes) {
    final text = buildTextTheme(scheme.onSurface, scheme.onSurfaceVariant, compact: sizes.compact);
    final control = BorderRadius.circular(sizes.controlRadius);
    final card = BorderRadius.circular(sizes.cardRadius);
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(borderRadius: control, borderSide: BorderSide(color: color, width: width));
    final buttonSize = Size(sizes.control, sizes.control);
    final buttonShape = RoundedRectangleBorder(borderRadius: control);
    const buttonPadding = EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      package: fontPackage,
      textTheme: text,
      scaffoldBackgroundColor: shell.canvas,
      canvasColor: scheme.surface,
      materialTapTargetSize: sizes.compact ? MaterialTapTargetSize.shrinkWrap : MaterialTapTargetSize.padded,
      visualDensity: sizes.compact ? VisualDensity.compact : VisualDensity.standard,
      extensions: [status, chart, shell, sizes],
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: shell.canvas,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: card,
          side: sizes.compact ? BorderSide(color: scheme.outlineVariant) : BorderSide.none,
        ),
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
        isDense: sizes.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: Space.md, vertical: sizes.compact ? 10 : Space.md),
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
        shape: RoundedRectangleBorder(borderRadius: card),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(sizes.cardRadius))),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(borderRadius: control),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surface,
        selectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        labelStyle: text.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: Space.md, vertical: sizes.compact ? Space.xs : Space.sm),
        showCheckmark: false,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        selectedIcon: const SizedBox.shrink(),
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: shell.navSelected,
          selectedForegroundColor: shell.onNavSelected,
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
          shape: buttonShape,
          minimumSize: buttonSize,
          textStyle: text.labelLarge,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: shell.nav,
        indicatorColor: shell.navSelected,
        selectedIconTheme: IconThemeData(color: shell.onNavSelected),
        unselectedIconTheme: IconThemeData(color: shell.onNavMuted),
        selectedLabelTextStyle: text.labelMedium?.copyWith(color: shell.onNavSelected, fontWeight: FontWeight.w600),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(color: shell.onNavMuted),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: sizes.compact ? Space.sm : Space.md,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodySmall,
        selectedColor: shell.onNavSelected,
        selectedTileColor: shell.navSelected,
        shape: RoundedRectangleBorder(borderRadius: control),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: text.labelLarge,
        unselectedLabelStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        dividerColor: scheme.outlineVariant,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHighest),
        thumbColor: WidgetStatePropertyAll(scheme.surface),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
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
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          isDense: sizes.compact,
          border: border(scheme.outline),
          enabledBorder: border(scheme.outline),
          focusedBorder: border(scheme.primary, 2),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
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
