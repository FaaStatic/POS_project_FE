import 'package:flutter/material.dart';

/// Two-series chart palette, validated with the dataviz checker against the
/// light (#FFFFFF) and dark (#09090B) surfaces. Series 2 is also dashed.
@immutable
class ChartColors extends ThemeExtension<ChartColors> {
  const ChartColors({required this.series1, required this.series2, required this.grid});

  final Color series1;
  final Color series2;
  final Color grid;

  static const light = ChartColors(series1: Color(0xFF15803D), series2: Color(0xFF2A78D6), grid: Color(0xFFE4E4E7));
  static const dark = ChartColors(series1: Color(0xFF16A34A), series2: Color(0xFF3987E5), grid: Color(0xFF27272A));

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
