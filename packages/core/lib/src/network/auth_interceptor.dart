import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_paths.dart';
import 'token_store.dart';

/// Returns a new access token, or null when the session cannot be renewed.
typedef TokenRefresher = Future<String?> Function();

/// Attaches the bearer token and, on 401, refreshes once and replays the request.
/// If refresh fails, [onSessionExpired] fires so the app can log out.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokens,
    required this._refresh,
    required this._retryDio,
    required this._onSessionExpired,
  });

  final TokenStore _tokens;
  final TokenRefresher _refresh;
  final Dio _retryDio;
  final void Function() _onSessionExpired;

  static const _retriedKey = 'auth_retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.accessToken;
    if (token != null && !ApiPaths.authPaths.contains(options.path)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final eligible = err.response?.statusCode == 401 &&
        !ApiPaths.authPaths.contains(options.path) &&
        options.extra[_retriedKey] != true;
    if (!eligible) return handler.next(err);

    // A queued request may already have been refreshed by the one before it.
    final sentWith = options.headers['Authorization'];
    final current = _tokens.accessToken;
    final token = current != null && sentWith != 'Bearer $current' ? current : await _refresh();

    if (token == null) {
      _onSessionExpired();
      return handler.next(err);
    }

    options.extra[_retriedKey] = true;
    options.headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await _retryDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) _onSessionExpired();
      handler.next(e);
    }
  }
}
