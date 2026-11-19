import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../common/tablet_layout.dart';
import '../../l10n/app_localizations.dart';
import 'destinations.dart';

/// Floating navigation pill on every window width. On the checkout of a tablet the order
/// panel runs the full height on the right and the pill floats under the catalog column only;
/// elsewhere it stays centered with phone-like proportions.
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

    final window = MediaQuery.sizeOf(context);
    final beside = shell.currentIndex == kasirCheckoutIndex && splitPaneFits(window);
    // The Scaffold no longer reserves the bar, so the pill hides while the keyboard is up
    // (it used to sit behind it) and the page leaves room for it, or the checkout does itself.
    final typing = MediaQuery.viewInsetsOf(context).bottom > 0;
    final reserve = typing ? 0.0 : _navHeight + Space.sm + MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: beside ? 0 : reserve,
            // Read inside the Scaffold: its body media already has the keyboard taken out.
            child: Builder(
              builder: (inner) {
                final media = MediaQuery.of(inner);
                return MediaQuery(
                  data: beside ? media.copyWith(padding: media.padding.copyWith(bottom: reserve)) : media.removePadding(removeBottom: true),
                  child: body,
                );
              },
            ),
          ),
          if (!typing)
            // Moves with the tab (the panel only exists on checkout) instead of jumping under the thumb.
            AnimatedPositioned(
              duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              left: 0,
              right: beside ? checkoutPanelWidth(window.width) : 0,
              bottom: 0,
              // NavigationBar pads itself by the top inset too (a Scaffold bottom bar had it removed), stretching the pill by the status bar.
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: _FloatingNav(
                  selected: shell.currentIndex,
                  onSelect: _go,
                  destinations: [for (final d in kasirDestinations) NavigationDestination(icon: Icon(d.icon), label: d.label(l10n))],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Height of the NavigationBar inside the pill.
const _navHeight = 68.0;

/// The navigation bar floats as a solid blue pill above the content.
class _FloatingNav extends StatelessWidget {
  const _FloatingNav({required this.selected, required this.onSelect, required this.destinations});
  final int selected;
  final ValueChanged<int> onSelect;
  final List<NavigationDestination> destinations;

  /// Tablet width: 60% of the column, kept between what five tabs need and a thumb's reach.
  static const _minWidth = 360.0;
  static const _maxWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = ShellColors.of(context);
    final light = theme.colorScheme.brightness == Brightness.light;
    Color fg(Set<WidgetState> s) => s.contains(WidgetState.selected) ? brand.onBrand : brand.onBrandMuted;
    final radius = BorderRadius.circular(Radii.large);
    // The pill sizes against the column it floats in: the window, or the catalog beside the order panel.
    return LayoutBuilder(
      builder: (context, column) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.sm),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: column.maxWidth < Breakpoints.medium ? double.infinity : (column.maxWidth * 0.6).clamp(_minWidth, _maxWidth),
              ),
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
                      height: _navHeight,
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
      ),
    );
  }
}
