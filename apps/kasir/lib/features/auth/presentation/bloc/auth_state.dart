import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Restoring the session from the stored refresh token at launch.
  const factory AuthState.unknown() = AuthUnknown;

  const factory AuthState.unauthenticated({
    @Default(false) bool submitting,
    Failure? failure,
    @Default(false) bool expired,
  }) = AuthUnauthenticated;

  const factory AuthState.authenticated(Session session) = AuthAuthenticated;
}
