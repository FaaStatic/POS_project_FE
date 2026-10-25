import 'package:dio/dio.dart';

import 'failure.dart';
import 'result.dart';

/// Runs a data-layer call and converts thrown errors into [Failure].
/// Only repository implementations use this; domain never sees Dio.
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } on DioException catch (e) {
    return Err(failureFromDio(e));
  } on FormatException catch (e) {
    return Err(ServerFailure(e.message));
  }
}

Failure failureFromDio(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.unknown when e.response == null:
      return const NetworkFailure();
    default:
      break;
  }
  final status = e.response?.statusCode;
  final message = _backendMessage(e.response?.data);
  return switch (status) {
    401 => UnauthorizedFailure(message),
    403 => ForbiddenFailure(message),
    404 => NotFoundFailure(message),
    409 => ConflictFailure(message),
    400 || 422 => ValidationFailure(message),
    _ => ServerFailure(message),
  };
}

/// Backend envelope: {success, message, data, error}. `error` is the specific
/// reason when present, `message` the generic one.
String? _backendMessage(Object? body) {
  if (body is! Map) return null;
  final error = body['error'];
  if (error is String && error.isNotEmpty) return error;
  final message = body['message'];
  return message is String && message.isNotEmpty ? message : null;
}
