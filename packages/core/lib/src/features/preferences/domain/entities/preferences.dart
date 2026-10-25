enum ThemePreference { system, light, dark }

/// Supported UI languages; Indonesian is the default.
enum AppLanguage {
  id,
  en;

  static AppLanguage parse(String? code) => values.firstWhere((l) => l.name == code, orElse: () => AppLanguage.id);
}
