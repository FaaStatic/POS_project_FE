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

/// Page frame: title, then a wrapping row of labelled page actions under it.
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
      ),
      floatingActionButton: fab,
      body: actions.isEmpty
          ? body
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Wrap(spacing: 8, runSpacing: 8, children: actions),
                ),
                Expanded(child: body),
              ],
            ),
    );
  }
}
