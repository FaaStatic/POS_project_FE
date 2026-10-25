import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/testing.dart';

void main() {
  late FakeAdapter adapter;
  late MemoryTokenStore tokens;
  late Dio dio;
  late int refreshCalls;
  late int expiredCalls;
  String? nextToken;

  setUp(() {
    adapter = FakeAdapter();
    tokens = MemoryTokenStore()..accessToken = 'old';
    refreshCalls = 0;
    expiredCalls = 0;
    nextToken = 'new';
    dio = fakeDio(adapter);
    dio.interceptors.add(AuthInterceptor(
      tokens: tokens,
      refresh: () async {
        refreshCalls++;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        tokens.accessToken = nextToken;
        return nextToken;
      },
      retryDio: fakeDio(adapter),
      onSessionExpired: () => expiredCalls++,
    ));
    adapter.on('GET', '/api/data', (o) {
      final ok = o.headers['Authorization'] == 'Bearer new';
      return FakeReply(ok ? 200 : 401, ok ? envelope('fresh') : errorBody('unauthorized'));
    });
  });

  test('attaches bearer token', () async {
    tokens.accessToken = 'new';
    await dio.get<dynamic>('/api/data');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer new');
  });

  test('does not attach token to login and refresh', () async {
    adapter.on('POST', '/auth/login', (_) => FakeReply(200, envelope(null)));
    await dio.post<dynamic>('/auth/login');
    expect(adapter.requests.single.headers.containsKey('Authorization'), isFalse);
  });

  test('refreshes once on 401 and replays the request', () async {
    final res = await dio.get<dynamic>('/api/data');
    expect(res.data['data'], 'fresh');
    expect(refreshCalls, 1);
    expect(expiredCalls, 0);
  });

  test('concurrent 401s share a single refresh', () async {
    final results = await Future.wait([dio.get<dynamic>('/api/data'), dio.get<dynamic>('/api/data')]);
    expect(results.map((r) => r.data['data']), ['fresh', 'fresh']);
    expect(refreshCalls, 1);
  });

  test('failed refresh expires the session and surfaces the 401', () async {
    nextToken = null;
    await expectLater(dio.get<dynamic>('/api/data'), throwsA(isA<DioException>()));
    expect(expiredCalls, 1);
  });

  test('a 401 on the replayed request expires the session', () async {
    nextToken = 'still-wrong';
    await expectLater(dio.get<dynamic>('/api/data'), throwsA(isA<DioException>()));
    expect(refreshCalls, 1);
    expect(expiredCalls, 1);
  });

  test('non-401 errors pass through untouched', () async {
    adapter.on('GET', '/api/boom', (_) => FakeReply(500, errorBody('boom')));
    await expectLater(dio.get<dynamic>('/api/boom'), throwsA(isA<DioException>()));
    expect(refreshCalls, 0);
  });
}
