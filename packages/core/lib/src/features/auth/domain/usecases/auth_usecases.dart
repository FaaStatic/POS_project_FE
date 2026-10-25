import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repo);
  final AuthRepository _repo;

  Future<Result<Session>> call({required String username, required String password}) {
    final name = username.trim();
    if (name.length < 3 || password.length < 6) {
      return Future.value(const Err(ValidationFailure()));
    }
    return _repo.login(username: name, password: password);
  }
}

class RestoreSession {
  const RestoreSession(this._repo);
  final AuthRepository _repo;

  Future<Result<Session>> call() => _repo.restore();
}

class Logout {
  const Logout(this._repo);
  final AuthRepository _repo;

  Future<void> call({String? fcmToken}) => _repo.logout(fcmToken: fcmToken);
}

class WatchSessionExpired {
  const WatchSessionExpired(this._repo);
  final AuthRepository _repo;

  Stream<void> call() => _repo.sessionExpired;
}

class GetCurrentSession {
  const GetCurrentSession(this._repo);
  final AuthRepository _repo;

  Session? call() => _repo.current;
}
