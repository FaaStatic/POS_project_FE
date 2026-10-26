import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';

/// Revenue and gross profit share one Rupiah axis. Profit is dashed so the
/// series differ by more than hue; a table view is one tap away.
class DailyChart extends StatefulWidget {
  const DailyChart({super.key, required this.days, required this.title});
  final List<DashboardDay> days;
  final String title;

  @override
  State<DailyChart> createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  bool _table = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = ChartColors.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final days = widget.days;
    final compact = NumberFormat.compact(locale: locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Space.lg,
          runSpacing: Space.sm,
          children: [
            Text(widget.title, style: theme.textTheme.titleLarge),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: theme.colorScheme.surfaceContainer),
              onPressed: () => setState(() => _table = !_table),
              child: Text(_table ? widget.title : l10n.chartTable),
            ),
          ],
        ),
        ),
        const SizedBox(height: Space.sm),
        Wrap(
          spacing: Space.lg,
          children: [
            _Legend(color: colors.series1, label: l10n.revenue),
            _Legend(color: colors.series2, label: l10n.grossProfit, dashed: true),
          ],
        ),
        const SizedBox(height: Space.xl),
        if (days.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xl),
            child: Text(l10n.noData),
          )
        else if (_table)
          _Table(days: days)
        else
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: colors.grid, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 56,
                      getTitlesWidget: (v, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(compact.format(v), style: theme.textTheme.labelSmall),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: (days.length / 6).ceilToDouble().clamp(1, 31),
                      getTitlesWidget: (v, meta) {
                        final i = v.round();
                        if (i < 0 || i >= days.length) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(DateFormat.Md(locale).format(days[i].date), style: theme.textTheme.labelSmall),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          '${s.barIndex == 0 ? l10n.revenue : l10n.grossProfit}\n${money(context, s.y)}',
                          theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.onInverseSurface),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  _line([
                    for (final (i, d) in days.indexed) FlSpot(i.toDouble(), d.revenue.toDouble()),
                  ], colors.series1),
                  _line(
                    [for (final (i, d) in days.indexed) FlSpot(i.toDouble(), d.grossProfit.toDouble())],
                    colors.series2,
                    dashed: true,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static LineChartBarData _line(List<FlSpot> spots, Color color, {bool dashed = false}) => LineChartBarData(
    spots: spots,
    color: color,
    barWidth: 2,
    isCurved: false,
    dashArray: dashed ? const [6, 4] : null,
    dotData: FlDotData(show: spots.length <= 14),
  );
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.dashed = false});
  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(width: 24, height: 12, child: CustomPaint(painter: _LegendLine(color, dashed))),
      const SizedBox(width: Space.sm),
      Flexible(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
    ],
  );
}

class _LegendLine extends CustomPainter {
  _LegendLine(this.color, this.dashed);
  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    final y = size.height / 2;
    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, y), Offset((x + 6).clamp(0, size.width), y), paint);
    }
  }

  @override
  bool shouldRepaint(_LegendLine old) => old.color != color || old.dashed != dashed;
}

class _Table extends StatelessWidget {
  const _Table({required this.days});
  final List<DashboardDay> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final num = Theme.of(context).textTheme.bodyMedium?.tabular;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.date)),
          DataColumn(label: Text(l10n.transactionCount), numeric: true),
          DataColumn(label: Text(l10n.revenue), numeric: true),
          DataColumn(label: Text(l10n.grossProfit), numeric: true),
        ],
        rows: [
          for (final d in days)
            DataRow(
              cells: [
                DataCell(Text(dateText(context, d.date))),
                DataCell(Text('${d.transactions}', style: num)),
                DataCell(Text(money(context, d.revenue), style: num)),
                DataCell(Text(money(context, d.grossProfit), style: num)),
              ],
            ),
        ],
      ),
    );
  }
}
