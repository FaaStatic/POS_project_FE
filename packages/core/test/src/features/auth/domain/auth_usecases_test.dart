import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  const session = Session(userId: 'u1', username: 'kasir1', role: UserRole.staff);

  setUp(() => repo = MockAuthRepository());

  test('Login trims the username and delegates', () async {
    when(() => repo.login(username: 'kasir1', password: 'secret1')).thenAnswer((_) async => const Ok(session));
    expect(await Login(repo)(username: '  kasir1 ', password: 'secret1'), const Ok(session));
  });

  test('Login rejects too-short input without calling the repository', () async {
    expect(await Login(repo)(username: 'ab', password: 'secret1'), const Err<Session>(ValidationFailure()));
    expect(await Login(repo)(username: 'kasir1', password: '123'), const Err<Session>(ValidationFailure()));
    verifyNever(() => repo.login(username: any(named: 'username'), password: any(named: 'password')));
  });

  test('RestoreSession delegates', () async {
    when(() => repo.restore()).thenAnswer((_) async => const Ok(session));
    expect(await RestoreSession(repo)(), const Ok(session));
  });

  test('Logout passes the FCM token', () async {
    when(() => repo.logout(fcmToken: 'f1')).thenAnswer((_) async {});
    await Logout(repo)(fcmToken: 'f1');
    verify(() => repo.logout(fcmToken: 'f1')).called(1);
  });
}
