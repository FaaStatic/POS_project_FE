import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAdapter adapter;
  late DeviceRepositoryImpl repo;

  setUp(() {
    adapter = FakeAdapter();
    repo = DeviceRepositoryImpl(ApiClient(fakeDio(adapter)));
  });

  test('list maps devices, filters platform; revoke and register', () async {
    adapter
      ..on('GET', ApiPaths.devices, (_) => FakeReply(200, envelope([
            {'id': 'd1', 'device_id': 'kasir-1', 'platform': 'ios', 'user_id': 'u1', 'username': 'kasir1', 'last_used_at': '2026-10-25T08:00:00Z'},
          ])))
      ..on('DELETE', ApiPaths.device('d1'), (_) => FakeReply(200, envelope(null)))
      ..on('POST', ApiPaths.fcmRegister, (_) => FakeReply(200, envelope(null)))
      ..on('POST', ApiPaths.fcmLogout, (_) => FakeReply(200, envelope(null)));
    final list = (await GetDevices(repo)(platform: DevicePlatform.ios) as Ok<List<Device>>).value;
    expect(list.single.username, 'kasir1');
    expect(list.single.platform, DevicePlatform.ios);
    expect(adapter.requests.first.queryParameters, {'platform': 'ios'});
    expect(await RevokeDevice(repo)('d1'), isA<Ok<void>>());
    expect(await RegisterPushToken(repo)(token: 't', platform: DevicePlatform.android, deviceId: 'x'), isA<Ok<void>>());
    expect(adapter.requests[2].data, {'token': 't', 'platform': 'android', 'device_id': 'x'});
    expect(await repo.unregister('t'), isA<Ok<void>>());
  });
}
