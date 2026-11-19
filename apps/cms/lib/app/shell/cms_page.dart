import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

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

/// Page frame: a slim white top bar (menu on narrow windows, language, account), then the page header
/// (title on the left, the page's actions on the right) and the body. The design credit lives on Settings.
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
    final scheme = theme.colorScheme;
    final heading = Semantics(
      header: true,
      child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
    );
    return Scaffold(
      floatingActionButton: fab,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: scheme.surface, border: Border(bottom: BorderSide(color: scheme.outlineVariant))),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  if (openMenu != null)
                    IconButton(icon: const Icon(Iconsax.menu_1_copy), tooltip: AppLocalizations.of(context).openMenu, onPressed: openMenu)
                  else
                    const SizedBox(width: Space.xl),
                  const Spacer(),
                  const _LanguageButton(),
                  const SizedBox(width: Space.xs),
                  const _AccountMenu(),
                  const SizedBox(width: Space.lg),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.xs),
            child: LayoutBuilder(
              builder: (context, box) {
                if (actions.isEmpty) return heading;
                // Wide: actions share the title row, right aligned. Narrow: they scroll sideways under it.
                if (box.maxWidth >= 760) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // A fixed ceiling, not Flexible: two flex children would split the row in half and squeeze the actions.
                      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 360), child: Padding(padding: const EdgeInsets.only(top: Space.xs), child: heading)),
                      const SizedBox(width: Space.lg),
                      // Expanded so the actions fill the rest of the row and hug its right edge.
                      Expanded(child: Wrap(alignment: WrapAlignment.end, spacing: Space.sm, runSpacing: Space.sm, children: actions)),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading,
                    const SizedBox(height: Space.md),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [for (final a in actions) Padding(padding: const EdgeInsets.only(right: Space.sm), child: a)]),
                    ),
                  ],
                );
              },
            ),
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
