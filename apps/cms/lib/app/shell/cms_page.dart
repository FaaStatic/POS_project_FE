import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../common/file_saver.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';

import '../../l10n/app_localizations.dart';

const designShotUrl = 'https://dribbble.com/shots/16763871-CMS-Dashboard-Design';

/// Gives the compact layout's page app bar a way to open the shell drawer.
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.openMenu, required super.child});

  final VoidCallback? openMenu;

  static VoidCallback? menuOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>()?.openMenu;

  @override
  bool updateShouldNotify(ShellScope old) => old.openMenu != openMenu;
}

/// Page frame: white top bar (title, language, account), a wrapping row of
/// labelled page actions, the body, and the design credit at the foot.
class CmsPage extends StatelessWidget {
  const CmsPage({super.key, required this.title, required this.body, this.actions = const [], this.fab});

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    final openMenu = ShellScope.menuOf(context);
    final theme = Theme.of(context);
    final narrow = MediaQuery.sizeOf(context).width < Breakpoints.medium;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: openMenu == null
            ? null
            : IconButton(
                icon: const Icon(Iconsax.menu_1_copy),
                tooltip: AppLocalizations.of(context).openMenu,
                onPressed: openMenu,
              ),
        toolbarHeight: 64,
        titleSpacing: openMenu == null ? Space.xl : 0,
        title: Text(title, style: theme.textTheme.titleLarge),
        backgroundColor: theme.colorScheme.surface,
        shape: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
        actions: const [_LanguageButton(), SizedBox(width: Space.xs), _AccountMenu(), SizedBox(width: Space.lg)],
      ),
      floatingActionButton: fab,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (actions.isNotEmpty)
            // Phones scroll the action row sideways instead of stacking it.
            narrow
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
                    child: Row(children: [for (final a in actions) Padding(padding: const EdgeInsets.only(right: Space.sm), child: a)]),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
                    child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: actions),
                  ),
          Expanded(child: body),
          DecoratedBox(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: DesignCredit(
                  title: 'CMS Dashboard Design',
                  author: 'Faysol Ahmed Sozib',
                  onOpen: () => openInNewTab(designShotUrl),
                ),
              ),
            ),
          ),
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
    return ShadButton.ghost(
      onPressed: () => settings.setLanguage(next),
      leading: const Icon(Iconsax.global_copy, size: 16),
      child: Text(settings.state.language.name.toUpperCase()),
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
      alignmentOffset: const Offset(0, Space.sm),
      menuChildren: [
        if (name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.sm),
            child: Text(l10n.signedInAs(name), style: Theme.of(context).textTheme.bodySmall),
          ),
        MenuItemButton(leadingIcon: const Icon(Iconsax.setting_2_copy, size: 18), onPressed: () => context.go('/settings'), child: Text(l10n.navSettings)),
        MenuItemButton(leadingIcon: const Icon(Iconsax.logout_copy, size: 18), onPressed: () => context.read<AuthCubit>().logout(), child: Text(l10n.logout)),
      ],
      builder: (context, controller, _) => Tooltip(
        message: l10n.account,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: Padding(padding: const EdgeInsets.all(Space.xs), child: InitialAvatar(name: name.isEmpty ? '?' : name, size: 36, square: false)),
        ),
      ),
    );
  }
}
