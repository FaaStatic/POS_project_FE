import '../../../../common/result.dart';
import '../entities/device.dart';
import '../repositories/device_repository.dart';

class RegisterPushToken {
  const RegisterPushToken(this._repo);
  final DeviceRepository _repo;

  Future<Result<void>> call({required String token, required DevicePlatform platform, required String deviceId}) =>
      _repo.register(token: token, platform: platform, deviceId: deviceId);
}

class GetDevices {
  const GetDevices(this._repo);
  final DeviceRepository _repo;

  Future<Result<List<Device>>> call({DevicePlatform? platform}) => _repo.list(platform: platform);
}

class RevokeDevice {
  const RevokeDevice(this._repo);
  final DeviceRepository _repo;

  Future<Result<void>> call(String id) => _repo.revoke(id);
}
