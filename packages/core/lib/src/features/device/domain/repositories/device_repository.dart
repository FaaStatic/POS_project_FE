import '../../../../common/result.dart';
import '../entities/device.dart';

abstract interface class DeviceRepository {
  Future<Result<void>> register({required String token, required DevicePlatform platform, required String deviceId});
  Future<Result<void>> unregister(String token);
  Future<Result<List<Device>>> list({DevicePlatform? platform});
  Future<Result<void>> revoke(String id);
}
