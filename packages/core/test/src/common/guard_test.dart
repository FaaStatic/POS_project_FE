import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/testing.dart';

void main() {
  late FakeAdapter adapter;
  late ApiClient api;

  setUp(() {
    adapter = FakeAdapter();
    api = ApiClient(fakeDio(adapter));
  });

  Future<Result<dynamic>> call() => guard(() => api.get('/x'));

  test('unwraps envelope data on success', () async {
    adapter.on('GET', '/x', (_) => FakeReply(200, envelope({'a': 1})));
    expect((await call() as Ok).value, {'a': 1});
  });

  final cases = <int, Failure>{
    401: const UnauthorizedFailure('bad token'),
    403: const ForbiddenFailure('bad token'),
    404: const NotFoundFailure('bad token'),
    409: const ConflictFailure('bad token'),
    400: const ValidationFailure('bad token'),
    500: const ServerFailure('bad token'),
  };
  cases.forEach((status, failure) {
    test('maps $status to ${failure.runtimeType} with backend error text', () async {
      adapter.on('GET', '/x', (_) => FakeReply(status, errorBody('generic', 'bad token')));
      expect(await call(), Err<dynamic>(failure));
    });
  });

  test('falls back to message when error is absent', () async {
    adapter.on('GET', '/x', (_) => FakeReply(409, errorBody('category in use')));
    expect(await call(), const Err<dynamic>(ConflictFailure('category in use')));
  });

  test('connection errors become NetworkFailure', () async {
    expect(await call(), const Err<dynamic>(NetworkFailure()));
  });

  test('timeouts become TimeoutFailure', () async {
    final result = await guard<void>(
      () => throw DioException.connectionTimeout(timeout: Duration.zero, requestOptions: RequestOptions()),
    );
    expect(result, const Err<void>(TimeoutFailure()));
  });

  test('Result.when dispatches both branches', () {
    expect(const Ok(1).when(ok: (v) => v + 1, err: (_) => 0), 2);
    expect(const Err<int>(NetworkFailure()).when(ok: (v) => v, err: (_) => -1), -1);
  });

  test('ApiClient drops null and empty query values', () async {
    adapter.on('GET', '/x', (_) => FakeReply(200, envelope(null)));
    await api.get('/x', query: {'a': null, 'b': '', 'c': 1});
    expect(adapter.requests.single.queryParameters, {'c': 1});
  });
}
