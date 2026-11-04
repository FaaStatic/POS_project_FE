import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../l10n/app_localizations.dart';
import 'destinations.dart';

/// Floating navigation pill on every window width; on tablets it keeps phone-like
/// proportions instead of stretching across the screen.
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
    // NavigationBar needs two destinations; a single-tab build shows the page alone.
    if (kasirDestinations.length < 2) return Scaffold(body: body);

    return Scaffold(
      body: body,
      bottomNavigationBar: _FloatingNav(
        selected: shell.currentIndex,
        onSelect: _go,
        destinations: [for (final d in kasirDestinations) NavigationDestination(icon: Icon(d.icon), label: d.label(l10n))],
      ),
    );
  }
}

/// The navigation bar floats as a solid blue pill above the content.
class _FloatingNav extends StatelessWidget {
  const _FloatingNav({required this.selected, required this.onSelect, required this.destinations});
  final int selected;
  final ValueChanged<int> onSelect;
  final List<NavigationDestination> destinations;

  /// Tablet width: 60% of the window, kept between what five tabs need and a thumb's reach.
  static const _minWidth = 360.0;
  static const _maxWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = ShellColors.of(context);
    final light = theme.colorScheme.brightness == Brightness.light;
    Color fg(Set<WidgetState> s) => s.contains(WidgetState.selected) ? brand.onBrand : brand.onBrandMuted;
    final width = MediaQuery.sizeOf(context).width;
    final pillWidth = width < Breakpoints.medium ? double.infinity : (width * 0.6).clamp(_minWidth, _maxWidth);
    final radius = BorderRadius.circular(Radii.large);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.sm),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: pillWidth),
            child: DecoratedBox(
              // shadcn shadow-md with a 1px edge a step lighter than the fill, so the pill reads on both themes.
              decoration: BoxDecoration(
                color: brand.brand,
                borderRadius: radius,
                border: Border.all(color: Color.alphaBlend(brand.onBrand.withValues(alpha: 0.16), brand.brand)),
                boxShadow: ShadShadows.md,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: NavigationBarTheme(
                  data: theme.navigationBarTheme.copyWith(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    height: 68,
                    // A lighter blue pill behind the open tab; white vs soft blue carries it too.
                    indicatorColor: light ? Azure.c700 : Azure.c800,
                    iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(color: fg(s))),
                    labelTextStyle: WidgetStateProperty.resolveWith(
                      (s) => theme.textTheme.labelSmall?.copyWith(color: fg(s), fontWeight: FontWeight.w600),
                    ),
                  ),
                  child: NavigationBar(selectedIndex: selected, onDestinationSelected: onSelect, destinations: destinations),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
