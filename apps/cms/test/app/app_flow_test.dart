import 'package:cms/app/app.dart';
import 'package:cms/app/di.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> loginData(String role) =>
    envelope({'id': 'u1', 'username': 'owner', 'role': role, 'token': 'a1', 'refresh_token': ''});

void main() {
  late FakeAdapter adapter;

  Future<void> pumpApp(WidgetTester tester, {Size size = const Size(1280, 800), double textScale = 1}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await getIt.reset();
    final api = ApiClient(Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter);
    setupDependencies(
      config: const AppConfig(baseUrl: 'http://api.test', flavor: 'dev'),
      store: MemoryStore(),
      api: api,
      bare: api,
      usesCookie: true,
    );
    await tester.pumpWidget(const CmsApp());
    await tester.pumpAndSettle();
  }

  setUp(() => adapter = FakeAdapter());

  testWidgets('no session on load shows login, then signs in to settings', (tester) async {
    adapter
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('invalid refresh token')))
      ..on('POST', ApiPaths.login, (_) => FakeReply(200, loginData('superadmin')))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': []})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])));
    await pumpApp(tester);
    expect(find.text('Masuk ke CMS'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah produk'), findsWidgets);
  });

  testWidgets('reload with a valid cookie restores straight into the app', (tester) async {
    adapter
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData('superadmin')))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': []})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])));
    await pumpApp(tester);
    expect(find.text('Tambah produk'), findsWidgets);
  });

  testWidgets('staff rejected by backend sees the admin-only message', (tester) async {
    adapter
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('invalid refresh token')))
      ..on('POST', ApiPaths.login, (_) => FakeReply(403, errorBody('forbidden', 'admin only')));
    await pumpApp(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'kasir');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.textContaining('CMS khusus admin toko'), findsOneWidget);
  });

  testWidgets('validation blocks short input before any request', (tester) async {
    adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('x')));
    await pumpApp(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    expect(find.text('Wajib diisi'), findsNWidgets(2));
    expect(adapter.requests.where((r) => r.path == ApiPaths.login), isEmpty);
  });

  testWidgets('network error at login is translated', (tester) async {
    adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('x')));
    await pumpApp(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada koneksi. Periksa internet lalu coba lagi.'), findsOneWidget);
  });

  testWidgets('switching language and theme, then logging out', (tester) async {
    adapter
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData('superadmin')))
      ..on('POST', ApiPaths.logout, (_) => FakeReply(200, envelope(null)))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': []})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])));
    await pumpApp(tester);
    await tester.tap(find.text('Pengaturan').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Signed in as owner'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Signed in as owner'))).brightness, Brightness.dark);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to CMS'), findsOneWidget);
  });

  testWidgets('compact width uses a drawer and login survives 200% text', (tester) async {
    adapter.on('POST', ApiPaths.refresh, (_) => FakeReply(401, errorBody('x')));
    await pumpApp(tester, size: const Size(360, 720), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Masuk ke CMS'), findsOneWidget);
  });

  testWidgets('compact shell opens the drawer from the page app bar', (tester) async {
    adapter
      ..on('POST', ApiPaths.refresh, (_) => FakeReply(200, loginData('superadmin')))
      ..on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({'product_list': []})))
      ..on('GET', ApiPaths.categories, (_) => FakeReply(200, envelope([])))
      ..on('GET', ApiPaths.users, (_) => FakeReply(200, envelope({'staff': []})));
    await pumpApp(tester, size: const Size(390, 800));
    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();
    expect(find.text('Shop CMS'), findsOneWidget);
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah staff'), findsWidgets);
  });
}
