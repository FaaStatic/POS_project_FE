import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// FCM wrapper. If Firebase fails to start, every call is a no-op and
/// [available] is false, so the cashier keeps working without push.
class PushService {
  PushService(this._register, this._devices, this._store);

  final RegisterPushToken _register;
  final DeviceRepository _devices;
  final KeyValueStore _store;
  bool available = false;
  String? _token;

  final _paymentUpdates = StreamController<String>.broadcast();
  final _opened = StreamController<String>.broadcast();

  /// Order ids from payment pushes received while the app runs.
  Stream<String> get paymentUpdates => _paymentUpdates.stream;

  /// Order ids from tapped notifications.
  Stream<String> get openedPayments => _opened.stream;

  String? get token => _token;

  Future<void> init(FirebaseOptions options) async {
    try {
      await Firebase.initializeApp(options: options);
      available = true;
    } catch (e) {
      debugPrint('Push disabled: Firebase failed to start ($e)');
      return;
    }
    FirebaseMessaging.onMessage.listen((m) => _emit(_paymentUpdates, m));
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _emit(_opened, m));
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _emit(_opened, initial);
  }

  /// Registers this device for payment pushes after sign-in.
  Future<void> registerDevice() async {
    if (!available) return;
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    // The backend sends with Admin SDK registration tokens; the FID from register() is unverified there.
    // ignore: deprecated_member_use
    _token = await messaging.getToken();
    final token = _token;
    if (token == null) return;
    await _register(token: token, platform: _platform, deviceId: await _deviceId());
    // ignore: deprecated_member_use
    messaging.onTokenRefresh.listen((t) async {
      _token = t;
      await _register(token: t, platform: _platform, deviceId: await _deviceId());
    });
  }

  Future<void> unregister() async {
    final token = _token;
    if (!available || token == null) return;
    await _devices.unregister(token);
  }

  static DevicePlatform get _platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? DevicePlatform.ios : DevicePlatform.android;

  Future<String> _deviceId() async {
    final existing = _store.getString('push_device_id');
    if (existing != null) return existing;
    final id = 'kasir-${DateTime.now().microsecondsSinceEpoch}';
    await _store.setString('push_device_id', id);
    return id;
  }

  static void _emit(StreamController<String> sink, RemoteMessage message) {
    final orderId = message.data['order_id'];
    if (orderId is String && orderId.isNotEmpty) sink.add(orderId);
  }
}
