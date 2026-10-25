import 'package:flutter/material.dart';

import '../../l10n/ui_localizations.dart';
import '../tokens/spacing.dart';

class TableColumnSpec<T> {
  const TableColumnSpec({
    required this.label,
    required this.cell,
    this.secondary = false,
    this.numeric = false,
    this.flex = 1,
  });

  final String label;
  final Widget Function(BuildContext context, T row) cell;

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

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final more = hasMore
          ? Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Center(
                child: OutlinedButton(
                  onPressed: loadingMore ? null : onLoadMore,
                  child: loadingMore
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(UiLocalizations.of(context).loadMore),
                ),
              ),
            )
          : null;
      if (width < Breakpoints.medium) return _cards(context, more);
      final visible = width > Breakpoints.expanded ? columns : columns.where((c) => !c.secondary).toList();
      return _table(context, visible, more);
    },
  );

  Widget _table(BuildContext context, List<TableColumnSpec<T>> visible, Widget? more) {
    final theme = Theme.of(context);
    final header = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    Widget cells(List<Widget> children) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
      child: Row(children: children),
    );
    // The table sits in one white card on the canvas.
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.lg),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          itemCount: rows.length + 1 + (more == null ? 0 : 1),
          itemBuilder: (context, i) {
            if (i == 0) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
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
            }
            if (i > rows.length) return more!;
            final row = rows[i - 1];
            return Material(
              key: ValueKey(rowKey(row)),
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap == null ? null : () => onTap!(row),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: TapSize.min + 8),
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
    );
  }

  static const _actionsWidth = 160.0;

  Widget _cards(BuildContext context, Widget? more) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return ListView.separated(
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
                  for (final c in columns.skip(1)) ...[
                    const SizedBox(height: Space.sm),
                    Text(c.label, style: label),
                    c.cell(context, row),
                  ],
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
