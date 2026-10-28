/// Failures crossing the data → domain boundary. [message] carries the backend
/// text as-is (v1 shows backend errors untranslated); local failures
/// (network, timeout, session expired) have none and are translated by the app.
sealed class Failure {
  const Failure([this.message]);
  final String? message;

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType && other is Failure && other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType($message)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

final class ConflictFailure extends Failure {
  const ConflictFailure([super.message]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

