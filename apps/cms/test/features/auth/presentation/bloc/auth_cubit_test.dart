import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cms/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late StreamController<void> expired;
  const owner = Session(userId: 'u1', username: 'owner', role: UserRole.superadmin);
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
    'restore authenticates a superadmin',
    setUp: () => when(() => repo.restore()).thenAnswer((_) async => const Ok(owner)),
    build: build,
    act: (c) => c.restore(),
    expect: () => [const AuthState.authenticated(owner)],
  );

  blocTest<AuthCubit, AuthState>(
    'restore failure goes to unauthenticated',
    setUp: () => when(() => repo.restore()).thenAnswer((_) async => const Err(UnauthorizedFailure())),
    build: build,
    act: (c) => c.restore(),
    expect: () => [const AuthState.unauthenticated()],
  );

  blocTest<AuthCubit, AuthState>(
    'login success emits submitting then authenticated',
    setUp: () => when(() => repo.login(username: 'owner', password: 'secret1')).thenAnswer((_) async => const Ok(owner)),
    build: build,
    act: (c) => c.login('owner', 'secret1'),
    expect: () => [const AuthState.unauthenticated(submitting: true), const AuthState.authenticated(owner)],
  );

  blocTest<AuthCubit, AuthState>(
    'login error carries the failure',
    setUp: () => when(() => repo.login(username: 'owner', password: 'secret1'))
        .thenAnswer((_) async => const Err(UnauthorizedFailure('invalid credentials'))),
    build: build,
    act: (c) => c.login('owner', 'secret1'),
    expect: () => [
      const AuthState.unauthenticated(submitting: true),
      const AuthState.unauthenticated(failure: UnauthorizedFailure('invalid credentials')),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'staff session is signed out with an admin-only failure',
    setUp: () => when(() => repo.login(username: 'kasir', password: 'secret1')).thenAnswer((_) async => const Ok(staff)),
    build: build,
    act: (c) => c.login('kasir', 'secret1'),
    expect: () => [
      const AuthState.unauthenticated(submitting: true),
      const AuthState.unauthenticated(failure: ForbiddenFailure()),
    ],
    verify: (_) => verify(() => repo.logout()).called(1),
  );

  blocTest<AuthCubit, AuthState>(
    'ignores a second submit while one is in flight',
    setUp: () => when(() => repo.login(username: 'owner', password: 'secret1')).thenAnswer((_) async => const Ok(owner)),
    build: build,
    seed: () => const AuthState.unauthenticated(submitting: true),
    act: (c) => c.login('owner', 'secret1'),
    expect: () => <AuthState>[],
  );

  blocTest<AuthCubit, AuthState>(
    'session expiry signs the user out',
    build: build,
    seed: () => const AuthState.authenticated(owner),
    act: (_) => expired.add(null),
    expect: () => [const AuthState.unauthenticated(expired: true)],
  );

  blocTest<AuthCubit, AuthState>(
    'logout clears the session',
    build: build,
    seed: () => const AuthState.authenticated(owner),
    act: (c) => c.logout(),
    expect: () => [const AuthState.unauthenticated()],
  );
}
