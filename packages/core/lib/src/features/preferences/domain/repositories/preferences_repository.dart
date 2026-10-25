import '../entities/preferences.dart';

abstract interface class PreferencesRepository {
  ThemePreference get theme;
  AppLanguage get language;
  Future<void> setTheme(ThemePreference theme);
  Future<void> setLanguage(AppLanguage language);
}
