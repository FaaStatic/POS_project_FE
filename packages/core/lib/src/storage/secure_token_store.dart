import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/token_store.dart';

/// Refresh token in Keychain (iOS) / Keystore-backed storage (Android).
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  static const _refreshKey = 'refresh_token';
  final FlutterSecureStorage _storage;

  @override
  String? accessToken;

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<void> writeRefreshToken(String? token) =>
      token == null ? _storage.delete(key: _refreshKey) : _storage.write(key: _refreshKey, value: token);

  @override
  Future<void> clear() async {
    accessToken = null;
    await _storage.delete(key: _refreshKey);
  }
}
