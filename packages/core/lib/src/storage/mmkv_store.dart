import 'package:mmkv/mmkv.dart';

import 'key_value_store.dart';

/// Call `MMKV.initialize()` before creating this.
class MmkvStore implements KeyValueStore {
  MmkvStore([MMKV? mmkv]) : _mmkv = mmkv ?? MMKV.defaultMMKV();

  final MMKV _mmkv;

  @override
  String? getString(String key) => _mmkv.decodeString(key);
  @override
  bool? getBool(String key) => _mmkv.containsKey(key) ? _mmkv.decodeBool(key) : null;
  @override
  int? getInt(String key) => _mmkv.containsKey(key) ? _mmkv.decodeInt(key) : null;
  @override
  Future<void> setString(String key, String value) async => _mmkv.encodeString(key, value);
  @override
  Future<void> setBool(String key, bool value) async => _mmkv.encodeBool(key, value);
  @override
  Future<void> setInt(String key, int value) async => _mmkv.encodeInt(key, value);
  @override
  Future<void> remove(String key) async => _mmkv.removeValue(key);
}
