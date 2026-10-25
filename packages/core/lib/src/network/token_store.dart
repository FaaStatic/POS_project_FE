/// Access token lives in memory; the refresh token lives in secure storage on
/// mobile and in an HttpOnly cookie on web (so web never sees it).
abstract interface class TokenStore {
  String? get accessToken;
  set accessToken(String? token);
  Future<String?> readRefreshToken();
  Future<void> writeRefreshToken(String? token);
  Future<void> clear();
}

class MemoryTokenStore implements TokenStore {
  String? _refresh;

  @override
  String? accessToken;

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<void> writeRefreshToken(String? token) async => _refresh = token;

  @override
  Future<void> clear() async {
    accessToken = null;
    _refresh = null;
  }
}
