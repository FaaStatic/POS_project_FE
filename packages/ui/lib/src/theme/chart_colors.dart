import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// Two-series chart palette, validated with the dataviz checker against the
/// light (#FFFFFF) and dark (#121A24) surfaces. Series 2 is also dashed.
@immutable
class ChartColors extends ThemeExtension<ChartColors> {
  const ChartColors({required this.series1, required this.series2, required this.grid});

  final Color series1;
  final Color series2;
  final Color grid;

  static const light = ChartColors(series1: Azure.c700, series2: Color(0xFFC37D16), grid: Neutral.border);
  static const dark = ChartColors(series1: Azure.c400, series2: Color(0xFFF9C982), grid: Neutral.borderDark);

  static ChartColors of(BuildContext context) => Theme.of(context).extension<ChartColors>()!;

  @override
  ChartColors copyWith({Color? series1, Color? series2, Color? grid}) =>
      ChartColors(series1: series1 ?? this.series1, series2: series2 ?? this.series2, grid: grid ?? this.grid);

  @override
  ChartColors lerp(ChartColors? other, double t) => other == null
      ? this
      : ChartColors(
          series1: Color.lerp(series1, other.series1, t)!,
          series2: Color.lerp(series2, other.series2, t)!,
          grid: Color.lerp(grid, other.grid, t)!,
        );
}
