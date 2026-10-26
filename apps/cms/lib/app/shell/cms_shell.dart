import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../l10n/app_localizations.dart';
import 'cms_page.dart';
import 'destinations.dart';

/// Drawer below 600, navigation rail up to 1024, persistent sidebar above.
/// All three sit on the ink surface.
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

    return _BrandNavTheme(
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        // NavigationRail needs two destinations; a single-section build uses the drawer.
        if (width < Breakpoints.medium || cmsDestinations.length < 2) {
          return Scaffold(
            key: _scaffold,
            drawer: _Sidebar(l10n: l10n, selected: index, onSelect: _go),
            body: ShellScope(openMenu: () => _scaffold.currentState?.openDrawer(), child: widget.shell),
          );
        }
        final shellColors = ShellColors.of(context);
        final nav = width <= Breakpoints.expanded
            ? NavigationRail(
                selectedIndex: index,
                onDestinationSelected: _go,
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.md),
                  child: _Mark(color: shellColors.foreground),
                ),
                destinations: [
                  for (final d in cmsDestinations) NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
                ],
              )
            : SizedBox(width: 280, child: _Sidebar(l10n: l10n, selected: index, onSelect: _go));
        return Scaffold(
          body: Row(children: [
            ColoredBox(color: shellColors.background, child: SafeArea(child: nav)),
            Expanded(child: ShellScope(openMenu: null, child: widget.shell)),
          ]),
        );
      }),
    );
  }
}

/// Recolors drawer and rail for the ink surface without touching page content.
class _BrandNavTheme extends StatelessWidget {
  const _BrandNavTheme({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shell = ShellColors.of(context);
    final label = theme.textTheme.labelLarge!;
    Color fg(Set<WidgetState> s) => s.contains(WidgetState.selected) ? shell.foreground : shell.muted;
    return Theme(
      data: theme.copyWith(
        navigationDrawerTheme: theme.navigationDrawerTheme.copyWith(
          backgroundColor: shell.background,
          indicatorColor: shell.selected,
          indicatorShape: const StadiumBorder(),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (s) => label.copyWith(color: fg(s), fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500),
          ),
          iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(color: fg(s), size: 22)),
        ),
        navigationRailTheme: theme.navigationRailTheme.copyWith(
          backgroundColor: shell.background,
          indicatorColor: shell.selected,
          selectedIconTheme: IconThemeData(color: shell.foreground),
          unselectedIconTheme: IconThemeData(color: shell.muted),
          selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(color: shell.foreground, fontWeight: FontWeight.w700),
          unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(color: shell.muted),
        ),
      ),
      child: child,
    );
  }
}

/// Text mark until the store has a logo.
class _Mark extends StatelessWidget {
  const _Mark({required this.color, this.withName = false});
  final Color color;
  final bool withName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shell = ShellColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: shell.indicator, borderRadius: BorderRadius.circular(Radii.medium)),
          child: Text('S', style: theme.textTheme.titleMedium?.copyWith(color: shell.onIndicator, fontWeight: FontWeight.w800)),
        ),
        if (withName) ...[
          const SizedBox(width: Space.md),
          Flexible(child: Text(l10n.appTitle, style: theme.textTheme.titleMedium?.copyWith(color: color))),
        ],
      ],
    );
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
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.xl, Space.xl),
            child: _Mark(color: ShellColors.of(context).foreground, withName: true),
          ),
          for (final d in cmsDestinations) NavigationDrawerDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
        ],
      );
}
