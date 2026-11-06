import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/ui_localizations.dart';
import '../theme/status_colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

class TransactionTab {
  const TransactionTab({
    required this.id,
    required this.number,
    required this.subtitle,
    this.highlight = false,
    this.label,
    this.closable = false,
  });
  final int id;
  final int number;

  /// Replaces "Transaksi N", for tabs that are not sales ("Hutang N").
  final String? label;

  /// "3 barang · Rp 27.500" or a status such as "Menunggu QRIS".
  final String subtitle;

  /// Status subtitles (waiting, paid) are drawn in the success color.
  final bool highlight;

  /// The active tab shows a close button when this is set and the strip has an `onClose`.
  final bool closable;
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
    this.onNewDebt,
    this.newDebtLabel = '',
    this.onClose,
    this.closeLabel = '',
  });

  final List<TransactionTab> tabs;
  final int? activeId;
  final ValueChanged<int> onSelect;
  final VoidCallback onNew;
  final VoidCallback onShowAll;

  /// Opens a debt payment tab; the action is left out when null.
  final VoidCallback? onNewDebt;
  final String newDebtLabel;

  /// Closes a tab; the close button is left out when null.
  final ValueChanged<int>? onClose;
  final String closeLabel;

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
              label: tab.label ?? l10n.tabLabel(tab.number),
              subtitle: tab.subtitle,
              highlight: tab.highlight,
              active: tab.id == widget.activeId,
              onTap: () => widget.onSelect(tab.id),
              onClose: tab.closable && tab.id == widget.activeId && widget.onClose != null ? () => widget.onClose!(tab.id) : null,
              closeLabel: widget.closeLabel,
            ),
            if (tab != widget.tabs.last) const SizedBox(width: Space.sm),
          ],
        ],
      ),
    );
    // Always visible, never scrolled away with the tabs. Phones get square icon
    // buttons so the tabs keep one row.
    return LayoutBuilder(builder: (context, constraints) {
      // Labelled actions need about 520 at normal text; large text switches to icon squares sooner.
      final compact = constraints.maxWidth < 520 * MediaQuery.textScalerOf(context).scale(1);
      final newBuyer = compact
          ? _SquareAction(tooltip: l10n.newBuyer, onTap: widget.onNew, child: const Icon(Icons.add_rounded))
          : AppButton(
              label: l10n.newBuyer,
              icon: Icons.add_rounded,
              variant: AppButtonVariant.outline,
              large: true,
              onPressed: widget.onNew,
            );
      final onNewDebt = widget.onNewDebt;
      final newDebt = onNewDebt == null
          ? null
          // The third labelled action only fits on a wide strip; below that it is an icon with a tooltip.
          : constraints.maxWidth < 860 * MediaQuery.textScalerOf(context).scale(1)
              ? _SquareAction(tooltip: widget.newDebtLabel, onTap: onNewDebt, child: const Icon(Icons.payments_outlined))
              : AppButton(
                  label: widget.newDebtLabel,
                  icon: Icons.payments_outlined,
                  variant: AppButtonVariant.outline,
                  large: true,
                  onPressed: onNewDebt,
                );
      final showAll = compact
          ? _SquareAction(
              tooltip: l10n.allTabs(widget.tabs.length),
              onTap: widget.onShowAll,
              child: Badge(
                label: Text('${widget.tabs.length}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Iconsax.shopping_cart_copy),
              ),
            )
          : AppButton(
              label: l10n.allTabs(widget.tabs.length),
              variant: AppButtonVariant.ghost,
              large: true,
              onPressed: widget.onShowAll,
            );
      return Row(children: [
        Expanded(child: tabs),
        newBuyer,
        if (newDebt != null) ...[const SizedBox(width: Space.sm), newDebt],
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
    this.onClose,
    this.closeLabel = '',
  });

  final String label;
  final String subtitle;
  final bool highlight;
  final bool active;
  final VoidCallback onTap;

  /// Only the open tab gets one (the strip decides), so a row of tabs does not turn into a row of crosses.
  final VoidCallback? onClose;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = StatusColors.of(context);
    final radius = BorderRadius.circular(Radii.medium);
    // Full-strength subtitle on the active blue tab: a faded one drops under 4.5:1.
    final edge = onClose == null ? Space.sm : Space.xs;
    final fg = active ? scheme.onPrimary : scheme.onSurface;
    final sub = active ? scheme.onPrimary : (highlight ? status.success : scheme.onSurfaceVariant);
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
            // The 48dp close button sets the height of the tab that has one.
            padding: EdgeInsets.fromLTRB(onClose == null ? Space.lg : Space.md, edge, onClose == null ? Space.lg : Space.xs, edge),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: theme.textTheme.labelLarge?.copyWith(color: fg)),
                    Text(subtitle, style: theme.textTheme.labelMedium?.tabular.copyWith(color: sub)),
                  ],
                ),
                if (onClose case final close?)
                  IconButton(
                    tooltip: closeLabel,
                    onPressed: close,
                    color: fg,
                    // 40 wide keeps the active tab inside a 360 phone's strip; the height is the full 48dp.
                    style: IconButton.styleFrom(minimumSize: const Size(40, 48), padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
