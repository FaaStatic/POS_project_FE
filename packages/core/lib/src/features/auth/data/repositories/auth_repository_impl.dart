import 'dart:async';

import '../../../../common/failure.dart';
import '../../../../common/guard.dart';
import '../../../../common/result.dart';
import '../../../../network/token_store.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  /// [usesCookie] is true on web, where the refresh token never reaches Dart.
  AuthRepositoryImpl({required this._remote, required this._tokens, required this._usesCookie});

  final AuthRemoteDatasource _remote;
  final TokenStore _tokens;
  final bool _usesCookie;
  final _expired = StreamController<void>.broadcast();
  Future<String?>? _inFlight;

  Session? _current;

  @override
  Session? get current => _current;

  @override
  Stream<void> get sessionExpired => _expired.stream;

  @override
  Future<Result<Session>> login({required String username, required String password}) async {
    final result = await guard(() => _remote.login(username, password));
    return switch (result) {
      Ok(:final value) => Ok(await _store(value)),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<Session>> restore() async {
    final refresh = _usesCookie ? null : await _tokens.readRefreshToken();
    if (!_usesCookie && refresh == null) return const Err(UnauthorizedFailure());
    final result = await guard(() => _remote.refresh(refresh));
    switch (result) {
      case Ok(:final value):
        return Ok(await _store(value));
      case Err(:final failure):
        // Keep the refresh token on network errors so the next launch can retry.
        if (failure is UnauthorizedFailure) await _tokens.clear();
        return Err(failure);
    }
  }

  /// Interceptor hook. Concurrent callers share one refresh request.
  Future<String?> refreshAccessToken() => _inFlight ??= _refreshOnce().whenComplete(() => _inFlight = null);

  Future<String?> _refreshOnce() async => switch (await restore()) {
        Ok() => _tokens.accessToken,
        Err() => null,
      };

  /// Interceptor hook: refresh failed or the retried request was still rejected.
  void expire() {
    _current = null;
    unawaited(_tokens.clear());
    _expired.add(null);
  }

  @override
  Future<void> logout({String? fcmToken}) async {
    final refresh = _usesCookie ? null : await _tokens.readRefreshToken();
    await guard(() => _remote.logout(refreshToken: refresh, fcmToken: fcmToken));
    _current = null;
    await _tokens.clear();
  }

  Future<Session> _store(LoginResponseModel model) async {
    _tokens.accessToken = model.token;
    final refresh = model.refreshToken;
    if (!_usesCookie && refresh != null && refresh.isNotEmpty) {
      await _tokens.writeRefreshToken(refresh);
    }
    return _current = model.toEntity();
  }
}
