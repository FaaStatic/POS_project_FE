import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login, this._restore, this._logout, WatchSessionExpired watchExpired)
    : super(const AuthState.unknown()) {
    _expiredSub = watchExpired().listen((_) => emit(const AuthState.unauthenticated(expired: true)));
  }

  final Login _login;
  final RestoreSession _restore;
  final Logout _logout;
  late final StreamSubscription<void> _expiredSub;

  Future<void> restore() async {
    final result = await _restore();
    emit(switch (result) {
      Ok(:final value) => AuthState.authenticated(value),
      Err() => const AuthState.unauthenticated(),
    });
  }

  Future<void> login(String username, String password) async {
    if (state case AuthUnauthenticated(submitting: true)) return;
    emit(const AuthState.unauthenticated(submitting: true));
    final result = await _login(username: username, password: password);
    emit(switch (result) {
      Ok(:final value) => AuthState.authenticated(value),
      Err(:final failure) => AuthState.unauthenticated(failure: failure),
    });
  }

  Future<void> logout({String? fcmToken}) async {
    await _logout(fcmToken: fcmToken);
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _expiredSub.cancel();
    return super.close();
  }
}
