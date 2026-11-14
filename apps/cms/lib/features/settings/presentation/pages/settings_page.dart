import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/shell/cms_page.dart';
import '../../../../common/file_saver.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/settings_cubit.dart';

/// Preferences laid out as web settings rows: what it is on the left, the control on the right.
/// Sign-out lives in the top bar's account menu, not here.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;

    return CmsPage(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.lg),
                  child: Text(l10n.settingsAppearance, style: theme.textTheme.titleMedium),
                ),
                const Divider(),
                _SettingRow(
                  label: l10n.language,
                  hint: l10n.settingsLanguageHint,
                  control: AppTabs<AppLanguage>(
                    choices: const [Choice(AppLanguage.id, 'Bahasa Indonesia'), Choice(AppLanguage.en, 'English')],
                    value: settings.language,
                    onChanged: context.read<SettingsCubit>().setLanguage,
                  ),
                ),
                const Divider(),
                _SettingRow(
                  label: l10n.theme,
                  hint: l10n.settingsThemeHint,
                  control: AppTabs<ThemePreference>(
                    choices: [
                      Choice(ThemePreference.system, l10n.themeSystem),
                      Choice(ThemePreference.light, l10n.themeLight),
                      Choice(ThemePreference.dark, l10n.themeDark),
                    ],
                    value: settings.theme,
                    onChanged: context.read<SettingsCubit>().setTheme,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          DesignCredit(
            title: 'CMS Dashboard Design',
            author: 'Faysol Ahmed Sozib',
            onOpen: () => openInNewTab(designShotUrl),
          ),
        ],
      ),
    );
  }
}

/// Label and hint on the left, the control on the right; stacked when the row is narrow.
class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.hint, required this.control});

  final String label;
  final String hint;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: Space.xs),
        Text(hint, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.lg),
      child: LayoutBuilder(
        builder: (context, box) => box.maxWidth < 560
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Space.md, children: [text, control])
            : Row(children: [Expanded(child: text), const SizedBox(width: Space.xl), control]),
      ),
    );
  }
}
