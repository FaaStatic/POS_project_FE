import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app/app.dart';
import 'package:kasir/app/di.dart';

Map<String, dynamic> loginData() =>
    envelope({'id': 'u2', 'username': 'kasir', 'role': 'staff', 'token': 'a1', 'refresh_token': 'r1'});

void main() {
  late FakeAdapter adapter;
  late MemoryTokenStore tokens;

  Future<void> pumpApp(WidgetTester tester, {double textScale = 1}) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await getIt.reset();
    final api = ApiClient(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    setupDependencies(
      config: const AppConfig(baseUrl: 'http://api.test', flavor: 'dev'),
      store: MemoryStore(),
      tokens: tokens,
      api: api,
      bare: api,
    );
    await tester.pumpWidget(const KasirApp());
    await tester.pumpAndSettle();
  }

  setUp(() {
    adapter = FakeAdapter();
    tokens = MemoryTokenStore();
  });

  testWidgets('first launch shows login; signing in stores the refresh token', (tester) async {
    adapter.on('POST', ApiPaths.login, (_) => FakeReply(200, loginData()));
    await pumpApp(tester);
    expect(find.text('Masuk Kasir'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'kasir');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk sebagai kasir'), findsOneWidget);
    expect(await tokens.readRefreshToken(), 'r1');
  });

  testWidgets('relaunch with a stored refresh token skips login', (tester) async {
    await tokens.writeRefreshToken('r0');
    adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData()));
    await pumpApp(tester);
    expect(find.text('Masuk sebagai kasir'), findsOneWidget);
  });

  testWidgets('login page survives 200% text', (tester) async {
    await pumpApp(tester, textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
