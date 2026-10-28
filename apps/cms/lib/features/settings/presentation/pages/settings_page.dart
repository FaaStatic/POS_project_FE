import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/shell/cms_page.dart';
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

    return CmsPage(
      title: l10n.settingsTitle,
      body: ConstrainedBody(
        padding: const EdgeInsets.all(Space.lg),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(Space.xl),
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
              const SizedBox(height: Space.xxl),
              account,
            ],
          ),
        ),
      ),
    );
  }
}
