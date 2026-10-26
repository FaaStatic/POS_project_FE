import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';

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
        toolbarHeight: 64,
        title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
        actions: const [_LanguageButton(), _AccountMenu(), SizedBox(width: 12)],
      ),
      floatingActionButton: fab,
      body: actions.isEmpty
          ? body
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phones scroll the action row sideways instead of stacking it.
                if (MediaQuery.sizeOf(context).width < 600)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(children: [for (final a in actions) Padding(padding: const EdgeInsets.only(right: 8), child: a)]),
                  )
                else
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

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>();
    final next = settings.state.language == AppLanguage.id ? AppLanguage.en : AppLanguage.id;
    return TextButton.icon(
      onPressed: () => settings.setLanguage(next),
      icon: const Icon(Iconsax.global, size: 20),
      label: Text(settings.state.language.name.toUpperCase()),
    );
  }
}

/// Initials avatar with the signed-in admin, settings, and sign-out.
class _AccountMenu extends StatelessWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthCubit>().state;
    final name = auth is AuthAuthenticated ? auth.session.username : '';
    return MenuAnchor(
      menuChildren: [
        if (name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(l10n.signedInAs(name), style: Theme.of(context).textTheme.bodySmall),
          ),
        MenuItemButton(leadingIcon: const Icon(Iconsax.setting_2), onPressed: () => context.go('/settings'), child: Text(l10n.navSettings)),
        MenuItemButton(leadingIcon: const Icon(Iconsax.logout), onPressed: () => context.read<AuthCubit>().logout(), child: Text(l10n.logout)),
      ],
      builder: (context, controller, _) => Tooltip(
        message: l10n.account,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: Padding(padding: const EdgeInsets.all(4), child: InitialAvatar(name: name.isEmpty ? '?' : name, size: 40, square: false)),
        ),
      ),
    );
  }
}
