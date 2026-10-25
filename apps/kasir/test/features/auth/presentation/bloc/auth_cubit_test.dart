import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late StreamController<void> expired;
  const staff = Session(userId: 'u2', username: 'kasir', role: UserRole.staff);

  setUp(() {
    repo = MockAuthRepository();
    expired = StreamController<void>.broadcast();
    when(() => repo.sessionExpired).thenAnswer((_) => expired.stream);
    when(() => repo.logout(fcmToken: any(named: 'fcmToken'))).thenAnswer((_) async {});
  });
  tearDown(() => expired.close());

  AuthCubit build() => AuthCubit(Login(repo), RestoreSession(repo), Logout(repo), WatchSessionExpired(repo));

  blocTest<AuthCubit, AuthState>(
    'restore authenticates staff',
    setUp: () => when(() => repo.restore()).thenAnswer((_) async => const Ok(staff)),
    build: build,
    act: (c) => c.restore(),
    expect: () => [const AuthState.authenticated(staff)],
  );

  blocTest<AuthCubit, AuthState>(
    'restore without a token goes to login',
    setUp: () => when(() => repo.restore()).thenAnswer((_) async => const Err(UnauthorizedFailure())),
    build: build,
    act: (c) => c.restore(),
    expect: () => [const AuthState.unauthenticated()],
  );

  blocTest<AuthCubit, AuthState>(
    'staff login succeeds',
    setUp: () => when(() => repo.login(username: 'kasir', password: 'secret1')).thenAnswer((_) async => const Ok(staff)),
    build: build,
    act: (c) => c.login('kasir', 'secret1'),
    expect: () => [const AuthState.unauthenticated(submitting: true), const AuthState.authenticated(staff)],
  );

  blocTest<AuthCubit, AuthState>(
    'login failure is surfaced',
    setUp: () => when(() => repo.login(username: 'kasir', password: 'secret1'))
        .thenAnswer((_) async => const Err(NetworkFailure())),
    build: build,
    act: (c) => c.login('kasir', 'secret1'),
    expect: () => [
      const AuthState.unauthenticated(submitting: true),
      const AuthState.unauthenticated(failure: NetworkFailure()),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'double submit is ignored',
    build: build,
    seed: () => const AuthState.unauthenticated(submitting: true),
    act: (c) => c.login('kasir', 'secret1'),
    expect: () => <AuthState>[],
  );

  blocTest<AuthCubit, AuthState>(
    'expiry and logout both end the session',
    build: build,
    seed: () => const AuthState.authenticated(staff),
    act: (c) async {
      expired.add(null);
      await Future<void>.delayed(Duration.zero);
      await c.logout(fcmToken: 'f1');
    },
    expect: () => [const AuthState.unauthenticated(expired: true), const AuthState.unauthenticated()],
    verify: (_) => verify(() => repo.logout(fcmToken: 'f1')).called(1),
  );
}
