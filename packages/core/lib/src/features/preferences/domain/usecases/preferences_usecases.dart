import '../entities/preferences.dart';
import '../repositories/preferences_repository.dart';

class GetPreferences {
  const GetPreferences(this._repo);
  final PreferencesRepository _repo;

  (ThemePreference, AppLanguage) call() => (_repo.theme, _repo.language);
}

class SetTheme {
  const SetTheme(this._repo);
  final PreferencesRepository _repo;

  Future<void> call(ThemePreference theme) => _repo.setTheme(theme);
}

class SetLanguage {
  const SetLanguage(this._repo);
  final PreferencesRepository _repo;

  Future<void> call(AppLanguage language) => _repo.setLanguage(language);
}
