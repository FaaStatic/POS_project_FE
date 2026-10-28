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
              destinations: [for (final d in kasirDestinations) NavigationDestination(icon: Icon(d.icon), label: d.label(l10n))],
            ),
          );
        }
        final shellColors = ShellColors.of(context);
        return Scaffold(
          body: Row(
            children: [
              // Wide windows: white rail with the open tab in mint, as in the CMS.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: shellColors.nav,
                  border: Border(right: BorderSide(color: shellColors.border)),
                ),
                child: SafeArea(
                  // Scrolls on short landscape tablets at large text instead of overflowing.
                  child: FillOrScroll(
                    child: NavigationRail(
                      selectedIndex: shell.currentIndex,
                      onDestinationSelected: _go,
                      labelType: NavigationRailLabelType.all,
                      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.control)),
                      destinations: [
                        for (final d in kasirDestinations) NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label(l10n))),
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

/// Narrow windows: the navigation bar floats as a solid mint pill above the content.
class _FloatingNav extends StatelessWidget {
  const _FloatingNav({required this.selected, required this.onSelect, required this.destinations});
  final int selected;
  final ValueChanged<int> onSelect;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = ShellColors.of(context);
    Color fg(Set<WidgetState> s) => s.contains(WidgetState.selected) ? brand.onBrand : brand.onBrandMuted;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.sm),
        child: Material(
          color: brand.brand,
          elevation: 6,
          shadowColor: const Color(0x33000000),
          borderRadius: BorderRadius.circular(Radii.large + 4),
          clipBehavior: Clip.antiAlias,
          child: NavigationBarTheme(
            data: theme.navigationBarTheme.copyWith(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 68,
              // A lighter mint pill behind the open tab; white vs soft mint carries it too.
              indicatorColor: theme.colorScheme.brightness == Brightness.light ? Mint.c700 : Mint.c800,
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
