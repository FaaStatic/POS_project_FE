import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Gives the compact layout's page app bar a way to open the shell drawer.
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.openMenu, required super.child});

  final VoidCallback? openMenu;

  static VoidCallback? menuOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>()?.openMenu;

  @override
  bool updateShouldNotify(ShellScope old) => old.openMenu != openMenu;
}

/// Page frame: title on the left, page actions on the right (quick access row
/// lives in the body, not here).
class CmsPage extends StatelessWidget {
  const CmsPage({super.key, required this.title, required this.body, this.actions = const [], this.fab});

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    final openMenu = ShellScope.menuOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: openMenu == null
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: AppLocalizations.of(context).openMenu,
                onPressed: openMenu,
              ),
        title: Text(title),
        actions: [...actions, const SizedBox(width: 8)],
      ),
      floatingActionButton: fab,
      body: body,
    );
  }
}
