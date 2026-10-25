import '../../../common/guard.dart';
import '../../../common/json.dart';
import '../../../common/result.dart';
import '../../../constants/api_paths.dart';
import '../../../network/api_client.dart';
import '../domain/entities/device.dart';
import '../domain/repositories/device_repository.dart';

Device deviceFromJson(Map<String, dynamic> j) => Device(
      id: readString(j['id']),
      deviceId: readString(j['device_id']),
      platform: DevicePlatform.parse(readString(j['platform'])),
      userId: readNullableString(j['user_id']),
      username: readNullableString(j['username']),
      lastUsedAt: readDate(j['last_used_at']),
      createdAt: readDate(j['created_at']),
    );

class DeviceRepositoryImpl implements DeviceRepository {
  const DeviceRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<Result<void>> register({required String token, required DevicePlatform platform, required String deviceId}) =>
      guard(() => _api.post(ApiPaths.fcmRegister, body: {'token': token, 'platform': platform.name, 'device_id': deviceId}));

  @override
  Future<Result<void>> unregister(String token) => guard(() => _api.post(ApiPaths.fcmLogout, body: {'token': token}));

  @override
  Future<Result<List<Device>>> list({DevicePlatform? platform}) => guard(() async {
        final data = await _api.get(ApiPaths.devices, query: {'platform': platform?.name});
        return readList(data is Map ? (data['devices'] ?? data['items']) : data).map(deviceFromJson).toList();
      });

  @override
  Future<Result<void>> revoke(String id) => guard(() => _api.delete(ApiPaths.device(id)));
}
