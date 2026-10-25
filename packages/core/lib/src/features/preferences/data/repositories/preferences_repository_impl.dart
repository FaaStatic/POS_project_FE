import '../../../../storage/key_value_store.dart';
import '../../domain/entities/preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  const PreferencesRepositoryImpl(this._store);
  final KeyValueStore _store;

  @override
  ThemePreference get theme => ThemePreference.values.firstWhere(
        (t) => t.name == _store.getString(PrefKeys.themeMode),
        orElse: () => ThemePreference.system,
      );

  @override
  AppLanguage get language => AppLanguage.parse(_store.getString(PrefKeys.locale));

  @override
  Future<void> setTheme(ThemePreference theme) => _store.setString(PrefKeys.themeMode, theme.name);

  @override
  Future<void> setLanguage(AppLanguage language) => _store.setString(PrefKeys.locale, language.name);
}
