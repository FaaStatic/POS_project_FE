import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../l10n/app_localizations.dart';
import 'cms_page.dart';
import 'destinations.dart';

/// Drawer below 600, navigation rail up to 1024, persistent sidebar above.
class CmsShell extends StatefulWidget {
  const CmsShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<CmsShell> createState() => _CmsShellState();
}

class _CmsShellState extends State<CmsShell> {
  final _scaffold = GlobalKey<ScaffoldState>();

  void _go(int index) {
    widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
    if (_scaffold.currentState?.isDrawerOpen ?? false) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final index = widget.shell.currentIndex;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // NavigationRail needs two destinations; a single-section build uses the drawer.
      if (width < Breakpoints.medium || cmsDestinations.length < 2) {
        return Scaffold(
          key: _scaffold,
          drawer: _Sidebar(l10n: l10n, selected: index, onSelect: _go),
          body: ShellScope(openMenu: () => _scaffold.currentState?.openDrawer(), child: widget.shell),
        );
      }
      final nav = width <= Breakpoints.expanded
          ? NavigationRail(
              selectedIndex: index,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in cmsDestinations)
                  NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
              ],
            )
          : SizedBox(width: 300, child: _Sidebar(l10n: l10n, selected: index, onSelect: _go));
      return Scaffold(
        body: Row(children: [
          SafeArea(child: nav),
          const VerticalDivider(width: 1),
          Expanded(child: ShellScope(openMenu: null, child: widget.shell)),
        ]),
      );
    });
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.l10n, required this.selected, required this.onSelect});

  final AppLocalizations l10n;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => NavigationDrawer(
        selectedIndex: selected,
        onDestinationSelected: onSelect,
        elevation: 0,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.xl, Space.lg),
            child: Text(l10n.appTitle, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final d in cmsDestinations)
            NavigationDrawerDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
        ],
      );
}
