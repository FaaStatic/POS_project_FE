import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/testing.dart';

Map<String, dynamic> loginData({String? refresh = 'r1', String token = 'a1', String role = 'staff'}) =>
    envelope({'id': 'u1', 'username': 'kasir1', 'role': role, 'token': token, 'refresh_token': refresh, 'expires_in': 900});

void main() {
  late FakeAdapter adapter;
  late MemoryTokenStore tokens;

  AuthRepositoryImpl repo({bool cookie = false}) {
    final api = ApiClient(fakeDio(adapter));
    return AuthRepositoryImpl(remote: AuthRemoteDatasource(api: api, bare: api), tokens: tokens, usesCookie: cookie);
  }

  setUp(() {
    adapter = FakeAdapter();
    tokens = MemoryTokenStore();
  });

  group('login', () {
    test('stores tokens and returns the session', () async {
      adapter.on('POST', ApiPaths.login, (_) => FakeReply(200, loginData()));
      final r = repo();
      final result = await r.login(username: 'kasir1', password: 'secret1');
      expect(result, const Ok(Session(userId: 'u1', username: 'kasir1', role: UserRole.staff)));
      expect(tokens.accessToken, 'a1');
      expect(await tokens.readRefreshToken(), 'r1');
      expect(r.current?.userId, 'u1');
    });

    test('web keeps no refresh token in Dart', () async {
      adapter.on('POST', ApiPaths.login, (_) => FakeReply(200, loginData(refresh: '', role: 'superadmin')));
      final result = await repo(cookie: true).login(username: 'owner', password: 'secret1');
      expect((result as Ok<Session>).value.role, UserRole.superadmin);
      expect(await tokens.readRefreshToken(), isNull);
    });

    test('maps 403 (staff on CMS) to ForbiddenFailure', () async {
      adapter.on('POST', ApiPaths.login, (_) => FakeReply(403, errorBody('forbidden', 'admin only')));
      expect(await repo(cookie: true).login(username: 'kasir1', password: 'secret1'),
          const Err<Session>(ForbiddenFailure('admin only')));
    });
  });

  group('restore', () {
    test('mobile without stored refresh token is unauthorized without a request', () async {
      expect(await repo().restore(), const Err<Session>(UnauthorizedFailure()));
      expect(adapter.requests, isEmpty);
    });

    test('mobile sends refresh token in the body and rotates it', () async {
      await tokens.writeRefreshToken('r0');
      adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData(refresh: 'r2', token: 'a2')));
      final result = await repo().restore();
      expect(result, isA<Ok<Session>>());
      expect(adapter.requests.single.data, {'refresh_token': 'r0'});
      expect(await tokens.readRefreshToken(), 'r2');
      expect(tokens.accessToken, 'a2');
    });

    test('web sends an empty body and relies on the cookie', () async {
      adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData(refresh: '')));
      await repo(cookie: true).restore();
      expect(adapter.requests.single.data, <String, dynamic>{});
    });

    test('rejected refresh clears tokens', () async {
      await tokens.writeRefreshToken('r0');
      adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('invalid refresh token')));
      expect(await repo().restore(), isA<Err<Session>>());
      expect(await tokens.readRefreshToken(), isNull);
    });

    test('network error keeps the refresh token for a later retry', () async {
      await tokens.writeRefreshToken('r0');
      expect(await repo().restore(), const Err<Session>(NetworkFailure()));
      expect(await tokens.readRefreshToken(), 'r0');
    });
  });

  test('refreshAccessToken shares one request between concurrent callers', () async {
    await tokens.writeRefreshToken('r0');
    adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData(token: 'a9')));
    final r = repo();
    expect(await Future.wait([r.refreshAccessToken(), r.refreshAccessToken()]), ['a9', 'a9']);
    expect(adapter.requests, hasLength(1));
  });

  test('refreshAccessToken returns null when refresh fails', () async {
    expect(await repo().refreshAccessToken(), isNull);
  });

  test('expire clears session and notifies listeners', () async {
    adapter.on('POST', ApiPaths.login, (_) => FakeReply(200, loginData()));
    final r = repo();
    await r.login(username: 'kasir1', password: 'secret1');
    final fired = expectLater(r.sessionExpired, emits(null));
    r.expire();
    await fired;
    expect(r.current, isNull);
    expect(tokens.accessToken, isNull);
  });

  test('logout sends refresh and fcm tokens, then clears even if the call fails', () async {
    await tokens.writeRefreshToken('r0');
    adapter.on('POST', ApiPaths.logout, (_) => FakeReply(500, errorBody('boom')));
    await repo().logout(fcmToken: 'f1');
    expect(adapter.requests.single.data, {'refresh_token': 'r0', 'fcm_token': 'f1'});
    expect(await tokens.readRefreshToken(), isNull);
  });
}
