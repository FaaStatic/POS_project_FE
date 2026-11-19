import 'package:flutter/material.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/app_theme.dart';
import '../tokens/spacing.dart';
import 'app_button.dart';

class TableColumnSpec<T> {
  const TableColumnSpec({
    required this.label,
    required this.cell,
    this.secondary = false,
    this.numeric = false,
    this.flex = 1,
    this.isEmpty,
  });

  final String label;
  final Widget Function(BuildContext context, T row) cell;

  /// Rows where this returns true drop the field from their card on phones.
  final bool Function(T row)? isEmpty;

  /// Hidden on medium widths (600–1024).
  final bool secondary;
  final bool numeric;
  final int flex;
}

/// Full table above 1024, table without secondary columns from 600, and a
/// list of cards below 600. Rows are keyboard focusable and open with Enter.
class ResponsiveTable<T> extends StatelessWidget {
  const ResponsiveTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.rowKey,
    this.onTap,
    this.actions,
    this.hasMore = false,
    this.loadingMore = false,
    this.onLoadMore,
    this.onRefresh,
  });

  final List<T> rows;
  final List<TableColumnSpec<T>> columns;
  final Object Function(T row) rowKey;
  final void Function(T row)? onTap;

  /// Trailing actions per row (buttons or a menu), always visible.
  final Widget Function(BuildContext context, T row)? actions;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  /// Pull to refresh; the future completes when the reload is done.
  final Future<void> Function()? onRefresh;

  Widget _refreshable(Widget list) => onRefresh == null ? list : RefreshIndicator(onRefresh: onRefresh!, child: list);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final more = hasMore
          ? Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Center(
                child: AppButton(
                  label: UiLocalizations.of(context).loadMore,
                  variant: AppButtonVariant.outline,
                  loading: loadingMore,
                  onPressed: onLoadMore,
                ),
              ),
            )
          : null;
      if (width < Breakpoints.medium) return _refreshable(_cards(context, more));
      final visible = width > Breakpoints.expanded ? columns : columns.where((c) => !c.secondary).toList();
      return _refreshable(_table(context, visible, more));
    },
  );

  Widget _table(BuildContext context, List<TableColumnSpec<T>> visible, Widget? more) {
    final theme = Theme.of(context);
    final sizes = AppSizes.of(context);
    final header = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    Widget cells(List<Widget> children) => Padding(
      padding: EdgeInsets.symmetric(horizontal: Space.lg, vertical: sizes.compact ? Space.sm : Space.md),
      // The gap keeps a right-aligned number off the text column beside it.
      child: Row(spacing: Space.lg, children: children),
    );
    // Web table: one white card, a header that stays put while the rows scroll, hairline rules, and a
    // hover tint so the pointer always shows which row an action belongs to.
    final headerRow = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: cells([
        for (final c in visible)
          Expanded(
            flex: c.flex,
            child: Text(c.label, style: header, textAlign: c.numeric ? TextAlign.end : TextAlign.start),
          ),
        if (actions != null)
          SizedBox(
            width: _actionsWidth,
            child: Text(UiLocalizations.of(context).actions, style: header, textAlign: TextAlign.end),
          ),
      ]),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.lg),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            headerRow,
            Expanded(
              child: ListView.builder(
                // A short list still has to be pullable.
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: rows.length + (more == null ? 0 : 1),
                itemBuilder: (context, i) {
                  if (i == rows.length) return more!;
                  final row = rows[i];
                  return Material(
                    key: ValueKey(rowKey(row)),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap == null ? null : () => onTap!(row),
                      hoverColor: theme.colorScheme.primary.withValues(alpha: 0.05),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: sizes.compact ? 48 : TapSize.min + 8),
                          child: cells([
                            for (final c in visible)
                              Expanded(
                                flex: c.flex,
                                child: Align(
                                  alignment: c.numeric ? Alignment.centerRight : Alignment.centerLeft,
                                  child: c.cell(context, row),
                                ),
                              ),
                            if (actions != null)
                              SizedBox(
                                width: _actionsWidth,
                                child: Align(alignment: Alignment.centerRight, child: actions!(context, row)),
                              ),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _actionsWidth = 160.0;

  Widget _cards(BuildContext context, Widget? more) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Space.lg),
      itemCount: rows.length + (more == null ? 0 : 1),
      separatorBuilder: (_, _) => const SizedBox(height: Space.md),
      itemBuilder: (context, i) {
        if (i == rows.length) return more!;
        final row = rows[i];
        return Card(
          key: ValueKey(rowKey(row)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap == null ? null : () => onTap!(row),
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(style: theme.textTheme.titleSmall, child: columns.first.cell(context, row)),
                  // Label left, value right: one line per field keeps several cards on screen.
                  for (final c in columns.skip(1))
                    if (!(c.isEmpty?.call(row) ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: Space.sm),
                        child: Row(
                          spacing: Space.md,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.label, style: label),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DefaultTextStyle.merge(textAlign: TextAlign.end, child: c.cell(context, row)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  if (actions != null) ...[
                    const SizedBox(height: Space.md),
                    Align(alignment: Alignment.centerRight, child: actions!(context, row)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
