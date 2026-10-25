import 'package:cms/features/staff/presentation/bloc/staff_cubit.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/cms_harness.dart';

class MockStaff extends Mock implements StaffRepository {}

Map<String, dynamic> staffJson(String id, String name, {bool active = true}) =>
    {'id': id, 'username': name, 'role': 'staff', 'active': active, 'created_at': '2026-10-01T00:00:00Z'};

void main() {
  setUpAll(() => registerFallbackValue(const StaffQuery()));

  group('StaffCubit', () {
    late MockStaff repo;
    late StaffCubit cubit;
    const s = Staff(id: 's1', username: 'kasir1', role: UserRole.staff);

    setUp(() {
      repo = MockStaff();
      when(() => repo.list(any(), after: any(named: 'after'))).thenAnswer((inv) async => Ok(Paged(
            items: [s],
            hasNext: inv.namedArguments[#after] == null,
            cursor: const PageCursor(id: 's1', time: 't'),
          )));
      cubit = StaffCubit(GetStaff(repo), RegisterStaff(repo), ResetStaffPassword(repo), DeactivateStaff(repo), RestoreStaff(repo), PurgeStaff(repo));
    });

    test('loads, pages, filters inactive and search', () async {
      await cubit.load();
      expect(cubit.state.items, [s]);
      await cubit.loadMore();
      expect(cubit.state.items, [s, s]);
      expect(cubit.state.hasNext, isFalse);
      cubit.showInactive(true);
      await Future<void>.delayed(Duration.zero);
      cubit.search('kas');
      await Future<void>.delayed(Duration.zero);
      final q = verify(() => repo.list(captureAny(), after: any(named: 'after'))).captured.last as StaffQuery;
      expect([q.inactive, q.search], [true, 'kas']);
    });

    test('actions reload on success and surface failures', () async {
      when(() => repo.deactivate('s1')).thenAnswer((_) async => const Ok(null));
      when(() => repo.restore('s1')).thenAnswer((_) async => const Err(ServerFailure('boom')));
      when(() => repo.resetPassword('s1', 'newpass1')).thenAnswer((_) async => const Ok(null));
      when(() => repo.register('kasir2', 'secret1')).thenAnswer((_) async => const Ok(null));
      when(() => repo.purge('s1', confirmUsername: 'kasir1')).thenAnswer((_) async => const Ok(PurgeMode.deleted));
      expect(await cubit.deactivate(s), isA<Ok<void>>());
      expect(await cubit.restore(s), const Err<void>(ServerFailure('boom')));
      expect(await cubit.resetPassword(s, 'newpass1'), isA<Ok<void>>());
      expect(await cubit.register('kasir2', 'secret1'), isA<Ok<void>>());
      expect(await cubit.purge(s, 'kasir1'), const Ok(PurgeMode.deleted));
      verify(() => repo.list(any(), after: any(named: 'after'))).called(3);
    });

    test('load failure is kept in state', () async {
      when(() => repo.list(any(), after: any(named: 'after'))).thenAnswer((_) async => const Err(NetworkFailure()));
      await cubit.load();
      expect(cubit.state.failure, const NetworkFailure());
      expect(cubit.state.loading, isFalse);
    });
  });

  testWidgets('staff page: list, add, reset password, purge by typing the name', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.users, (_) => FakeReply(200, envelope({'has_next': false, 'staff': [staffJson('s1', 'kasir1')]})))
      ..on('POST', ApiPaths.register, (_) => FakeReply(201, envelope(null)))
      ..on('PATCH', ApiPaths.user('s1'), (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.userPurge('s1'), (_) => FakeReply(200, envelope({'mode': 'anonymized'})));
    await app.pump(tester, location: '/staff');
    expect(find.text('kasir1'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Tambah staff'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'kasir2');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Staff ditambahkan.'), findsOneWidget);
    expect(app.adapter.requests.where((r) => r.path == ApiPaths.register).single.data, {'username': 'kasir2', 'password': 'secret1'});

    await tester.tap(find.widgetWithText(OutlinedButton, 'Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset password'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'newpass1');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Password diganti. Sesi staff ini dicabut.'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Aksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus permanen'));
    await tester.pumpAndSettle();
    final purge = find.widgetWithText(FilledButton, 'Hapus permanen');
    expect(tester.widget<FilledButton>(purge).onPressed, isNull);
    await tester.enterText(find.byType(TextField).last, 'kasir1');
    await tester.pump();
    await tester.tap(purge);
    await tester.pumpAndSettle();
    expect(find.text('Punya riwayat transaksi, jadi dianonimkan.'), findsOneWidget);
  });

  testWidgets('staff page empty and error states', (tester) async {
    final app = CmsHarness();
    var fail = true;
    app.adapter.on('GET', ApiPaths.users, (_) => fail ? FakeReply(500, errorBody('down')) : FakeReply(200, envelope({'staff': []})));
    await app.pump(tester, location: '/staff', size: const Size(390, 800));
    expect(find.textContaining('Gagal memuat data'), findsOneWidget);
    fail = false;
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada staff. Tambah staff pertama.'), findsOneWidget);
  });
}
