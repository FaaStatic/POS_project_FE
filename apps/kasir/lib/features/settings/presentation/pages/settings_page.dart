import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/shell/kasir_page.dart';
import '../../../../common/master_detail.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/settings_cubit.dart';

const designShotUrl = 'https://dribbble.com/shots/27265995-Mobile-App-Design-for-POS-Cashier-Management-for-Small-Store';

/// [account] and [sync] are supplied by the app layer (signed-in user and
/// sign-out; manual sync of the offline queue).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.account, required this.sync, required this.flavor});

  final Widget account;
  final Widget sync;

  /// `dev`, `staging` or `prod`, from [AppConfig.flavor].
  final String flavor;

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
            Card(clipBehavior: Clip.antiAlias, child: sync),
            const SizedBox(height: Space.md),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.box_copy),
                    title: Text(l10n.navProducts),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => openDetail(context, 'products', '/settings/products'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.printer_copy),
                    title: Text(l10n.printerTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => openDetail(context, 'printer', '/settings/printer'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.shop_copy),
                    title: Text(l10n.storeInfo),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => openDetail(context, 'store', '/settings/store'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            SurfaceCard(
              child: Column(
                children: [
                  _SettingRow(
                    label: l10n.language,
                    control: SymbolToggle<AppLanguage>(
                      choices: const [
                        SymbolChoice(AppLanguage.id, 'Bahasa Indonesia', text: 'ID'),
                        SymbolChoice(AppLanguage.en, 'English', text: 'EN'),
                      ],
                      value: settings.language,
                      onChanged: context.read<SettingsCubit>().setLanguage,
                    ),
                  ),
                  const Divider(),
                  _SettingRow(
                    label: l10n.theme,
                    control: SymbolToggle<ThemePreference>(
                      choices: [
                        SymbolChoice(ThemePreference.system, l10n.themeSystem, icon: Iconsax.autobrightness_copy, selectedIcon: Iconsax.autobrightness),
                        SymbolChoice(ThemePreference.light, l10n.themeLight, icon: Iconsax.sun_1_copy, selectedIcon: Iconsax.sun_1),
                        SymbolChoice(ThemePreference.dark, l10n.themeDark, icon: Iconsax.moon_copy, selectedIcon: Iconsax.moon),
                      ],
                      value: settings.theme,
                      onChanged: context.read<SettingsCubit>().setTheme,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            SurfaceCard(child: account),
            const SizedBox(height: Space.sm),
            Center(
              child: Text(
                l10n.environmentLabel(switch (flavor) {
                  'prod' => 'Production',
                  'staging' => 'Staging',
                  _ => 'Dev',
                }),
                style: theme.textTheme.bodySmall,
              ),
            ),
            const Center(child: AppVersionLabel()),
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

/// A label on the left and its symbol toggle on the right, one line per setting.
class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.control});

  final String label;
  final Widget control;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Row(
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
            control,
          ],
        ),
      );
}

/// `Versi 0.1.0 (1)` from the installed build; nothing is shown if the platform cannot tell.
class AppVersionLabel extends StatefulWidget {
  const AppVersionLabel({super.key});

  @override
  State<AppVersionLabel> createState() => _AppVersionLabelState();
}

class _AppVersionLabelState extends State<AppVersionLabel> {
  // Read once: a future created in build would hit the platform channel on every rebuild.
  final _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
        future: _info,
        builder: (context, snapshot) {
          final info = snapshot.data;
          if (info == null) return const SizedBox.shrink();
          return Text(
            AppLocalizations.of(context).appVersionLabel('${info.version} (${info.buildNumber})'),
            style: Theme.of(context).textTheme.bodySmall,
          );
        },
      );
}
