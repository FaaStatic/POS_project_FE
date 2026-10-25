import '../../../../common/result.dart';
import '../entities/session.dart';

abstract interface class AuthRepository {
  Session? get current;

  /// Emits when a refresh fails and the user has to sign in again.
  Stream<void> get sessionExpired;

  Future<Result<Session>> login({required String username, required String password});

  /// Renews the session from the stored refresh token (mobile) or cookie (web).
  Future<Result<Session>> restore();

  /// Revokes the session server-side when possible; local tokens are always cleared.
  Future<void> logout({String? fcmToken});
}
