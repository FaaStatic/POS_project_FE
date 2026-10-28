import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/shell/kasir_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/settings_cubit.dart';

const designShotUrl = 'https://dribbble.com/shots/27265995-Mobile-App-Design-for-POS-Cashier-Management-for-Small-Store';

/// [account] is supplied by the app layer (signed-in user and sign-out).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.account});

  final Widget account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;

    return KasirPage(
      title: l10n.navMore,
      body: ConstrainedBody(
        child: ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.box_copy),
                    title: Text(l10n.navProducts),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/products'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.printer_copy),
                    title: Text(l10n.printerTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/printer'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.shop_copy),
                    title: Text(l10n.storeInfo),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/store'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.language, style: theme.textTheme.titleSmall),
                  const SizedBox(height: Space.sm),
                  AppTabs<AppLanguage>(
                    choices: const [Choice(AppLanguage.id, 'Bahasa Indonesia'), Choice(AppLanguage.en, 'English')],
                    value: settings.language,
                    onChanged: context.read<SettingsCubit>().setLanguage,
                  ),
                  const SizedBox(height: Space.xl),
                  Text(l10n.theme, style: theme.textTheme.titleSmall),
                  const SizedBox(height: Space.sm),
                  AppTabs<ThemePreference>(
                    choices: [
                      Choice(ThemePreference.system, l10n.themeSystem),
                      Choice(ThemePreference.light, l10n.themeLight),
                      Choice(ThemePreference.dark, l10n.themeDark),
                    ],
                    value: settings.theme,
                    onChanged: context.read<SettingsCubit>().setTheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            SurfaceCard(child: account),
            const SizedBox(height: Space.sm),
            Center(
              child: DesignCredit(
                title: 'Mobile App Design for POS',
                author: 'Vinz',
                onOpen: () => launchUrl(Uri.parse(designShotUrl), mode: LaunchMode.externalApplication),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
