import 'package:bloc_test/bloc_test.dart';
import 'package:cms/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PreferencesRepositoryImpl repo;
  setUp(() => repo = PreferencesRepositoryImpl(MemoryStore()));

  SettingsCubit build() => SettingsCubit(GetPreferences(repo), SetTheme(repo), SetLanguage(repo));

  test('every theme preference maps to a ThemeMode by name', () {
    for (final p in ThemePreference.values) {
      expect(ThemeMode.values.byName(p.name).name, p.name);
    }
  });

  test('starts from stored preferences', () {
    expect(build().state, const SettingsState(theme: ThemePreference.system, language: AppLanguage.id));
  });

  blocTest<SettingsCubit, SettingsState>(
    'setTheme and setLanguage emit and persist',
    build: build,
    act: (c) async {
      await c.setTheme(ThemePreference.dark);
      await c.setLanguage(AppLanguage.en);
    },
    expect: () => [
      const SettingsState(theme: ThemePreference.dark, language: AppLanguage.id),
      const SettingsState(theme: ThemePreference.dark, language: AppLanguage.en),
    ],
    verify: (_) => expect(GetPreferences(repo)(), (ThemePreference.dark, AppLanguage.en)),
  );
}
