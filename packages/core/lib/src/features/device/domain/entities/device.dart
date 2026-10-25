import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';

enum DevicePlatform {
  android,
  ios;

  static DevicePlatform parse(String raw) => raw.toLowerCase() == 'ios' ? ios : android;
}

/// A signed-in device holding an FCM token (`device_tokens`).
@freezed
abstract class Device with _$Device {
  const factory Device({
    required String id,
    required String deviceId,
    required DevicePlatform platform,
    String? userId,
    String? username,
    DateTime? lastUsedAt,
    DateTime? createdAt,
  }) = _Device;
}
