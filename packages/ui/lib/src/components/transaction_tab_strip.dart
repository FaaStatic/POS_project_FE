import 'package:flutter/material.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/shell_colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

class TransactionTab {
  const TransactionTab({required this.id, required this.number, required this.subtitle, this.highlight = false});
  final int id;
  final int number;

  /// "3 barang · Rp 27.500" or a status such as "Menunggu QRIS".
  final String subtitle;

  /// Status subtitles (waiting, paid) are drawn in the primary color.
  final bool highlight;
}

/// "Transaksi N" tabs as a scrolling row of pills. The active tab is filled with
/// the brand green and scrolled into view; "Pembeli baru" and "Semua (N)" follow.
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
    final scheme = Theme.of(context).colorScheme;
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
    // Always visible, never scrolled away with the tabs.
    final actions = [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.medium)),
          minimumSize: const Size(TapSize.min, 56),
          side: BorderSide(color: scheme.outlineVariant),
          backgroundColor: scheme.surface,
        ),
        onPressed: widget.onNew,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(l10n.newBuyer),
      ),
      TextButton(
        style: TextButton.styleFrom(minimumSize: const Size(TapSize.min, 56)),
        onPressed: widget.onShowAll,
        child: Text(l10n.allTabs(widget.tabs.length)),
      ),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 520) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            tabs,
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.sm, 0),
              child: Wrap(alignment: WrapAlignment.end, spacing: Space.xs, children: actions),
            ),
          ],
        );
      }
      return Row(children: [
        Expanded(child: tabs),
        ...actions,
        const SizedBox(width: Space.sm),
      ]);
    });
  }
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
    final shell = ShellColors.of(context);
    final radius = BorderRadius.circular(Radii.medium);
    final fg = active ? shell.foreground : scheme.onSurface;
    final sub = active ? shell.indicator : (highlight ? scheme.primary : scheme.onSurfaceVariant);
    return Semantics(
      selected: active,
      button: true,
      child: Material(
        color: active ? shell.background : scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: radius, side: active ? BorderSide.none : BorderSide(color: scheme.outlineVariant)),
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
