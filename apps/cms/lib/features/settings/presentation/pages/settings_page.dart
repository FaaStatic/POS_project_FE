import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/shell/cms_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;
    final auth = context.watch<AuthCubit>().state;

    return CmsPage(
      title: l10n.settingsTitle,
      body: ConstrainedBody(
        padding: const EdgeInsets.all(Space.xl),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (auth case AuthAuthenticated(:final session))
              Text(l10n.signedInAs(session.username), style: theme.textTheme.bodyLarge),
            const SizedBox(height: Space.xl),
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
            const SizedBox(height: Space.xxl),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: l10n.logout,
                variant: AppButtonVariant.outline,
                onPressed: () => context.read<AuthCubit>().logout(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
