import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../../../app/shell/kasir_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/settings_cubit.dart';

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
                    leading: const Icon(Iconsax.box),
                    title: Text(l10n.navProducts),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/products'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.printer),
                    title: Text(l10n.printerTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/printer'),
                  ),
                  const Divider(indent: Space.lg, endIndent: Space.lg),
                  ListTile(
                    leading: const Icon(Iconsax.shop),
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
                  SegmentedButton<AppLanguage>(
                    segments: const [
                      ButtonSegment(value: AppLanguage.id, label: Text('Bahasa Indonesia')),
                      ButtonSegment(value: AppLanguage.en, label: Text('English')),
                    ],
                    selected: {settings.language},
                    onSelectionChanged: (s) => context.read<SettingsCubit>().setLanguage(s.first),
                  ),
                  const SizedBox(height: Space.xl),
                  Text(l10n.theme, style: theme.textTheme.titleSmall),
                  const SizedBox(height: Space.sm),
                  SegmentedButton<ThemePreference>(
                    segments: [
                      ButtonSegment(value: ThemePreference.system, label: Text(l10n.themeSystem)),
                      ButtonSegment(value: ThemePreference.light, label: Text(l10n.themeLight)),
                      ButtonSegment(value: ThemePreference.dark, label: Text(l10n.themeDark)),
                    ],
                    selected: {settings.theme},
                    onSelectionChanged: (s) => context.read<SettingsCubit>().setTheme(s.first),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            SurfaceCard(child: account),
          ],
        ),
      ),
    );
  }
}
