import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
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

/// Horizontally scrolling "Transaksi N" tabs. The active tab is scrolled into
/// view; "Pembeli baru" and "Semua (N)" stay pinned on the right.
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
          Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 200), alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
          Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 200), alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = UiLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    _keys.removeWhere((id, _) => widget.tabs.every((t) => t.id != id));

    final tabs = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in widget.tabs)
            _Tab(
              key: _keys.putIfAbsent(tab.id, GlobalKey.new),
              label: l10n.tabLabel(tab.number),
              subtitle: tab.subtitle,
              highlight: tab.highlight,
              active: tab.id == widget.activeId,
              onTap: () => widget.onSelect(tab.id),
            ),
        ],
      ),
    );
    final actions = [
      TextButton.icon(onPressed: widget.onNew, icon: const Icon(Iconsax.add, size: 20), label: Text(l10n.newBuyer)),
      TextButton(onPressed: widget.onShowAll, child: Text(l10n.allTabs(widget.tabs.length))),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.outlineVariant))),
      child: LayoutBuilder(builder: (context, constraints) {
        // Narrow windows put the actions on their own row so labels never shrink.
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tabs,
              Align(alignment: Alignment.centerRight, child: Wrap(children: actions)),
            ],
          );
        }
        return Row(children: [Expanded(child: tabs), const SizedBox(width: Space.xs), ...actions, const SizedBox(width: Space.xs)]);
      }),
    );
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
    return Semantics(
      selected: active,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: TapSize.min + 8, minWidth: 120),
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: active ? scheme.primary : Colors.transparent, width: 3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge?.copyWith(color: active ? scheme.primary : scheme.onSurface)),
              Text(
                subtitle,
                style: theme.textTheme.labelMedium?.tabular.copyWith(
                  color: highlight ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
