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
    final body = Column(children: [?banner, Expanded(child: shell)]);
    // NavigationBar/Rail need two destinations; a single-tab build shows the page alone.
    if (kasirDestinations.length < 2) return Scaffold(body: body);

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Breakpoints.medium) {
        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _go,
            destinations: [
              for (final d in kasirDestinations) NavigationDestination(icon: Icon(d.icon), label: d.label(l10n)),
            ],
          ),
        );
      }
      return Scaffold(
        body: Row(children: [
          SafeArea(
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
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ]),
      );
    });
  }
}
