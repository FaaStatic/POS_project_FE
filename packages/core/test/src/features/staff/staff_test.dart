import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAdapter adapter;
  late StaffRepositoryImpl repo;
  const staff = Staff(id: 's1', username: 'kasir1', role: UserRole.staff);

  setUp(() {
    adapter = FakeAdapter();
    repo = StaffRepositoryImpl(ApiClient(fakeDio(adapter)));
  });

  test('list maps staff and sends status', () async {
    adapter.on('GET', ApiPaths.users, (_) => FakeReply(200, envelope({
          'has_next': false,
          'staff': [
            {'id': 's1', 'username': 'kasir1', 'role': 'staff', 'active': false, 'created_at': '2026-10-01T00:00:00Z'},
          ],
        })));
    final page = (await GetStaff(repo)(const StaffQuery(inactive: true, search: 'kas')) as Ok<Paged<Staff>>).value;
    expect(page.items.single.active, isFalse);
    expect(adapter.requests.single.queryParameters, {'status': 'inactive', 'search': 'kas', 'limit': 50});
  });

  test('register and reset validate locally, reset sends only the password', () async {
    adapter
      ..on('POST', ApiPaths.register, (_) => FakeReply(201, envelope(null)))
      ..on('PATCH', ApiPaths.user('s1'), (_) => FakeReply(200, envelope(null)));
    expect(await RegisterStaff(repo)('ab', 'secret1'), const Err<void>(ValidationFailure('username_length')));
    expect(await RegisterStaff(repo)('kasir2', '123'), const Err<void>(ValidationFailure('password_length')));
    expect(await RegisterStaff(repo)(' kasir2 ', 'secret1'), isA<Ok<void>>());
    expect(adapter.requests.last.data, {'username': 'kasir2', 'password': 'secret1'});
    expect(await ResetStaffPassword(repo)('s1', '12'), isA<Err<void>>());
    expect(await ResetStaffPassword(repo)('s1', 'newpass1'), isA<Ok<void>>());
    expect(adapter.requests.last.data, {'password': 'newpass1'});
  });

  test('deactivate, restore, purge with typed name', () async {
    adapter
      ..on('DELETE', ApiPaths.user('s1'), (_) => FakeReply(200, envelope(null)))
      ..on('POST', ApiPaths.userRestore('s1'), (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.userPurge('s1'), (_) => FakeReply(200, envelope({'mode': 'anonymized'})));
    expect(await DeactivateStaff(repo)('s1'), isA<Ok<void>>());
    expect(await RestoreStaff(repo)('s1'), isA<Ok<void>>());
    expect(await PurgeStaff(repo)(staff, 'kasir'), const Err<PurgeMode>(ValidationFailure('confirm_mismatch')));
    expect(await PurgeStaff(repo)(staff, ' kasir1 '), const Ok(PurgeMode.anonymized));
    expect(adapter.requests.last.data, {'confirm': 'kasir1'});
  });
}
