import 'package:flutter/material.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/status_colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

class TransactionTab {
  const TransactionTab({required this.id, required this.number, required this.subtitle, this.highlight = false});
  final int id;
  final int number;

  /// "3 barang · Rp 27.500" or a status such as "Menunggu QRIS".
  final String subtitle;

  /// Status subtitles (waiting, paid) are drawn in the success color.
  final bool highlight;
}

/// "Transaksi N" tabs as a scrolling row. The active tab is ink and scrolled into
/// view; "Pembeli baru" and "Semua (N)" stay pinned at the end.
class TransactionTabStrip extends StatefulWidget {
  const TransactionTabStrip({
    super.key,
    required this.tabs,
    required this.activeId,
    required this.onSelect,
    required this.onNew,
    required this.onShowAll,
  });

  final List<TransactionTab> tabs;
  final int? activeId;
  final ValueChanged<int> onSelect;
  final VoidCallback onNew;
  final VoidCallback onShowAll;

  @override
  State<TransactionTabStrip> createState() => _TransactionTabStripState();
}

class _TransactionTabStripState extends State<TransactionTabStrip> {
  final _keys = <int, GlobalKey>{};

  @override
  void didUpdateWidget(TransactionTabStrip old) {
    super.didUpdateWidget(old);
    if (old.activeId != widget.activeId || old.tabs.length != widget.tabs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _keys[widget.activeId]?.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 200), alignment: 0.5);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    _keys.removeWhere((id, _) => widget.tabs.every((t) => t.id != id));
    final tabs = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      child: Row(
        children: [
          for (final tab in widget.tabs) ...[
            _Tab(
              key: _keys.putIfAbsent(tab.id, GlobalKey.new),
              label: l10n.tabLabel(tab.number),
              subtitle: tab.subtitle,
              highlight: tab.highlight,
              active: tab.id == widget.activeId,
              onTap: () => widget.onSelect(tab.id),
            ),
            if (tab != widget.tabs.last) const SizedBox(width: Space.sm),
          ],
        ],
      ),
    );
    // Always visible, never scrolled away with the tabs. Phones get square icon
    // buttons so the tabs keep one row.
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 520;
      final newBuyer = compact
          ? _SquareAction(tooltip: l10n.newBuyer, onTap: widget.onNew, child: const Icon(Icons.add_rounded))
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(TapSize.min, 56),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.medium)),
              ),
              onPressed: widget.onNew,
              icon: const Icon(Icons.add_rounded, size: 22),
              label: Text(l10n.newBuyer),
            );
      final showAll = compact
          ? _SquareAction(
              tooltip: l10n.allTabs(widget.tabs.length),
              onTap: widget.onShowAll,
              child: Badge(
                label: Text('${widget.tabs.length}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Icons.view_agenda_outlined),
              ),
            )
          : TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(TapSize.min, 56)),
              onPressed: widget.onShowAll,
              child: Text(l10n.allTabs(widget.tabs.length)),
            );
      return Row(children: [
        Expanded(child: tabs),
        newBuyer,
        const SizedBox(width: Space.sm),
        showAll,
        SizedBox(width: compact ? Space.lg : Space.sm),
      ]);
    });
  }
}

class _SquareAction extends StatelessWidget {
  const _SquareAction({required this.tooltip, required this.onTap, required this.child});
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onTap,
    style: IconButton.styleFrom(
      minimumSize: const Size.square(56),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.medium)),
    ),
    icon: child,
  );
}

class _Tab extends StatelessWidget {
  const _Tab({
    super.key,
    required this.label,
    required this.subtitle,
    required this.highlight,
    required this.active,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool highlight;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = StatusColors.of(context);
    final radius = BorderRadius.circular(Radii.medium);
    // Primary, not the shell ink: in dark mode the ink equals the card surface.
    final fg = active ? scheme.onPrimary : scheme.onSurface;
    final sub = active ? scheme.onPrimary.withValues(alpha: 0.7) : (highlight ? status.success : scheme.onSurfaceVariant);
    return Semantics(
      selected: active,
      button: true,
      child: Material(
        color: active ? scheme.primary : scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 56, minWidth: 128),
            padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge?.copyWith(color: fg)),
                Text(subtitle, style: theme.textTheme.labelMedium?.tabular.copyWith(color: sub)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
