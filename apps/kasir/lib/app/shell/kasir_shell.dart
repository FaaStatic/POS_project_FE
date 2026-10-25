import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../l10n/app_localizations.dart';
import 'destinations.dart';

/// Navigation bar on narrow windows, navigation rail on wide ones.
class KasirShell extends StatelessWidget {
  const KasirShell({super.key, required this.shell, this.banner});

  final StatefulNavigationShell shell;

  /// Offline / pending-sync banner shown above every tab.
  final Widget? banner;

  void _go(int index) => shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final body = Column(
      children: [
        ?banner,
        Expanded(child: shell),
      ],
    );
    // NavigationBar/Rail need two destinations; a single-tab build shows the page alone.
    if (kasirDestinations.length < 2) return Scaffold(body: body);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.medium) {
          return Scaffold(
            body: body,
            bottomNavigationBar: _FloatingNav(
              selected: shell.currentIndex,
              onSelect: _go,
              destinations: [
                for (final d in kasirDestinations) NavigationDestination(icon: Icon(d.icon), label: d.label(l10n)),
              ],
            ),
          );
        }
        final theme = Theme.of(context);
        final brand = ShellColors.of(context);
        return Scaffold(
          body: Row(
            children: [
              // Wide windows: rail on the brand green, matching the checkout header.
              Theme(
                data: theme.copyWith(
                  navigationRailTheme: theme.navigationRailTheme.copyWith(
                    backgroundColor: brand.background,
                    indicatorColor: brand.indicator,
                    selectedIconTheme: IconThemeData(color: brand.onIndicator),
                    unselectedIconTheme: IconThemeData(color: brand.foreground),
                    selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
                      color: brand.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(color: brand.muted),
                  ),
                ),
                child: ColoredBox(
                  color: brand.background,
                  child: SafeArea(
                    child: NavigationRail(
                      selectedIndex: shell.currentIndex,
                      onDestinationSelected: _go,
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        for (final d in kasirDestinations)
                          NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

/// Narrow windows: the navigation bar floats as a green pill above the content.
class _FloatingNav extends StatelessWidget {
  const _FloatingNav({required this.selected, required this.onSelect, required this.destinations});
  final int selected;
  final ValueChanged<int> onSelect;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = ShellColors.of(context);
    Color fg(Set<WidgetState> s) => s.contains(WidgetState.selected) ? brand.foreground : brand.muted;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.sm),
        child: Material(
          color: brand.background,
          elevation: 6,
          shadowColor: const Color(0x33000000),
          borderRadius: BorderRadius.circular(Radii.large + 4),
          clipBehavior: Clip.antiAlias,
          child: NavigationBarTheme(
            data: theme.navigationBarTheme.copyWith(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 68,
              indicatorColor: brand.selected,
              iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(color: fg(s))),
              labelTextStyle: WidgetStateProperty.resolveWith(
                (s) => theme.textTheme.labelSmall?.copyWith(color: fg(s), fontWeight: FontWeight.w600),
              ),
            ),
            child: NavigationBar(selectedIndex: selected, onDestinationSelected: onSelect, destinations: destinations),
          ),
        ),
      ),
    );
  }
}
