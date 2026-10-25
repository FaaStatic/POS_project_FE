import 'package:shared_preferences/shared_preferences.dart';

/// Small preferences (theme, locale, printer, store info). Reads are synchronous.
abstract interface class KeyValueStore {
  String? getString(String key);
  bool? getBool(String key);
  int? getInt(String key);
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);
  Future<void> setInt(String key, int value);
  Future<void> remove(String key);
}

/// Web implementation (mmkv has no web support).
class PrefsStore implements KeyValueStore {
  PrefsStore._(this._prefs);

  static Future<PrefsStore> create() async => PrefsStore._(
        await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions()),
      );

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);
  @override
  bool? getBool(String key) => _prefs.getBool(key);
  @override
  int? getInt(String key) => _prefs.getInt(key);
  @override
  Future<void> setString(String key, String value) => _prefs.setString(key, value);
  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  @override
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);
  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

class MemoryStore implements KeyValueStore {
  final _values = <String, Object>{};

  @override
  String? getString(String key) => _values[key] as String?;
  @override
  bool? getBool(String key) => _values[key] as bool?;
  @override
  int? getInt(String key) => _values[key] as int?;
  @override
  Future<void> setString(String key, String value) async => _values[key] = value;
  @override
  Future<void> setBool(String key, bool value) async => _values[key] = value;
  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;
  @override
  Future<void> remove(String key) async => _values.remove(key);
}

abstract final class PrefKeys {
  static const themeMode = 'theme_mode';
  static const locale = 'locale';
}
