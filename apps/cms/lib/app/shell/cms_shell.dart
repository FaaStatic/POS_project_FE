import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../l10n/app_localizations.dart';
import 'cms_page.dart';
import 'destinations.dart';

/// Drawer below 600, navigation rail up to 1024, persistent sidebar above.
/// All three are white; the open page is marked in mint.
class CmsShell extends StatefulWidget {
  const CmsShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<CmsShell> createState() => _CmsShellState();
}

class _CmsShellState extends State<CmsShell> {
  final _scaffold = GlobalKey<ScaffoldState>();

  /// Sections the admin folded away; shared by the sidebar and the drawer.
  final _collapsed = <String>{};

  void _go(int index) {
    widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
    if (_scaffold.currentState?.isDrawerOpen ?? false) Navigator.of(context).pop();
  }

  void _toggle(String group) => setState(() => _collapsed.contains(group) ? _collapsed.remove(group) : _collapsed.add(group));

  @override
  Widget build(BuildContext context) {
    final index = widget.shell.currentIndex;
    final shell = ShellColors.of(context);
    final sidebar = _Sidebar(selected: index, collapsed: _collapsed, onSelect: _go, onToggle: _toggle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // NavigationRail needs two destinations; a single-section build uses the drawer.
        if (width < Breakpoints.medium || cmsDestinations.length < 2) {
          return Scaffold(
            key: _scaffold,
            drawer: Drawer(backgroundColor: shell.nav, shape: const RoundedRectangleBorder(), child: sidebar),
            body: ShellScope(openMenu: () => _scaffold.currentState?.openDrawer(), child: widget.shell),
          );
        }
        final l10n = AppLocalizations.of(context);
        final nav = width <= Breakpoints.expanded
            // Eleven destinations outgrow a short window (1024 × 768), so the rail scrolls there.
            ? FillOrScroll(
                child: NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: _go,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: Space.md),
                    child: BrandLogo.mark(),
                  ),
                  destinations: [
                    for (final d in cmsDestinations) NavigationRailDestination(icon: Icon(d.icon, size: 20), label: Text(d.label(l10n))),
                  ],
                ),
              )
            : SizedBox(width: 248, child: sidebar);
        return Scaffold(
          body: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: shell.nav,
                  border: Border(right: BorderSide(color: shell.border)),
                ),
                child: SafeArea(child: nav),
              ),
              Expanded(child: ShellScope(openMenu: null, child: widget.shell)),
            ],
          ),
        );
      },
    );
  }
}


/// White sidebar: brand, Dashboard, then foldable sections in branch order.
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selected, required this.collapsed, required this.onSelect, required this.onToggle});

  final int selected;
  final Set<String> collapsed;
  final ValueChanged<int> onSelect;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final children = <Widget>[];
    String? section;
    for (final (i, d) in cmsDestinations.indexed) {
      final group = d.group?.call(l10n);
      if (group != null && group != section) {
        section = group;
        children.add(
          _SectionHeader(
            label: group,
            // The open page's section never folds away under the admin.
            expanded: !collapsed.contains(group) || cmsDestinations[selected].group?.call(l10n) == group,
            onTap: () => onToggle(group),
          ),
        );
      }
      if (group == null || !collapsed.contains(group) || i == selected) {
        children.add(_NavItem(icon: d.icon, label: d.label(l10n), selected: i == selected, onTap: () => onSelect(i)));
      }
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Space.md, Space.xl, Space.md, Space.lg),
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(Space.sm, 0, Space.sm, Space.xl), child: BrandLogo.pos(height: 40)),
          ...children,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.expanded, required this.onTap});
  final String label;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shell = ShellColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Space.lg, bottom: Space.xs),
      child: Semantics(
        expanded: expanded,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.small),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs + 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(label, style: theme.textTheme.labelLarge?.copyWith(color: shell.onNav)),
                ),
                AnimatedRotation(
                  turns: expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(Iconsax.arrow_down_1_copy, size: 14, color: shell.onNavMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shell = ShellColors.of(context);
    final radius = BorderRadius.circular(Radii.small + 2);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? shell.navSelected : Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: Space.md),
              // The bar marks the open page, not decoration.
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: selected ? theme.colorScheme.primary : Colors.transparent, width: 3)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: selected ? shell.onNavSelected : shell.onNavMuted),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: selected ? shell.onNavSelected : shell.onNav,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
