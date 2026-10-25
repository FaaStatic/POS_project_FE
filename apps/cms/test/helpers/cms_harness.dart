import 'package:cms/app/app.dart';
import 'package:cms/app/di.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> ownerLogin() =>
    envelope({'id': 'u1', 'username': 'owner', 'role': 'superadmin', 'token': 'a1', 'refresh_token': ''});

/// CMS on a scripted backend, already signed in through the refresh cookie.
class CmsHarness {
  final adapter = FakeAdapter();

  Future<void> pump(WidgetTester tester, {String? location, Size size = const Size(1280, 900), double textScale = 1}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    adapter.routes.putIfAbsent('POST ${ApiPaths.refresh}', () => (_) => FakeReply(200, ownerLogin()));
    await getIt.reset();
    final api = ApiClient(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    setupDependencies(
      config: const AppConfig(baseUrl: 'http://api.test', flavor: 'dev'),
      store: MemoryStore(),
      api: api,
      bare: api,
      usesCookie: true,
    );
    await tester.pumpWidget(CmsApp(initialLocation: location));
    await tester.pumpAndSettle();
  }
}
