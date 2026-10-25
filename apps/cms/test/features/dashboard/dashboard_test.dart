import 'package:cms/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/cms_harness.dart';

class MockDashboard extends Mock implements DashboardRepository {}

class MockDebts extends Mock implements DebtRepository {}

class MockPayments extends Mock implements PaymentRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const DebtQuery());
    registerFallbackValue(const PaymentQuery());
  });

  test('cubit loads summary with needs-action data and switches ranges', () async {
    final dash = MockDashboard(), debts = MockDebts(), payments = MockPayments();
    final summary = dashboardFromJson(dashboardJson(conflicts: 2), DateTime(2026), DateTime(2026));
    when(() => dash.summary(start: any(named: 'start'), end: any(named: 'end'))).thenAnswer((_) async => Ok(summary));
    when(() => debts.list(any(), after: any(named: 'after')))
        .thenAnswer((_) async => const Ok(Paged(items: [Debt(id: 'd', customerId: 'k', total: 1, remaining: 1, paid: false)])));
    when(() => payments.list(any(), after: any(named: 'after'))).thenAnswer((inv) async => Ok(Paged(items: [
          if ((inv.positionalArguments.first as PaymentQuery).state == PaymentState.expired)
            const PaymentRecord(id: 'p', orderId: 'o', method: ChargeMethod.qris, state: PaymentState.expired, grossAmount: 1),
        ])));
    final cubit = DashboardCubit(GetDashboard(dash), GetDebts(debts), GetPayments(payments), clock: () => DateTime(2026, 10, 25, 9));
    await cubit.load();
    expect(cubit.state.summary?.openStockConflicts, 2);
    expect(cubit.state.oldestDebts, hasLength(1));
    expect(cubit.state.failedPayments, 1);
    expect(cubit.state.nothingToDo, isFalse);
    expect(cubit.state.start, DateTime(2026, 9, 26));
    await cubit.select(DashboardRange.today);
    expect(cubit.state.start, DateTime(2026, 10, 25));
    await cubit.select(DashboardRange.custom, start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 10));
    expect(cubit.state.range, DashboardRange.custom);
    verify(() => dash.summary(start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 10))).called(1);

    when(() => dash.summary(start: any(named: 'start'), end: any(named: 'end'))).thenAnswer((_) async => const Err(NetworkFailure()));
    await cubit.load();
    expect(cubit.state.failure, const NetworkFailure());
  });

  testWidgets('nothing to do: single line, key numbers, details, chart table', (tester) async {
    final app = CmsHarness();
    serveDashboard(app.adapter);
    await app.pump(tester, location: '/dashboard');
    expect(find.text('Tidak ada yang perlu ditindaklanjuti hari ini.'), findsOneWidget);
    expect(find.text('Rp 2.500.000'), findsOneWidget);
    expect(find.text('Indomie Goreng'), findsOneWidget);
    expect(find.text('80%'), findsNothing);
    expect(find.textContaining('100× · 80%'), findsOneWidget);
    expect(find.text('Omzet dan laba kotor harian, 30 hari'), findsOneWidget);
    await tester.tap(find.text('Lihat sebagai tabel'));
    await tester.pumpAndSettle();
    expect(find.byType(DataTable), findsOneWidget);
  });

  testWidgets('needs action rows open their follow-up screens', (tester) async {
    final app = CmsHarness();
    serveDashboard(app.adapter, conflicts: 3, oldDebt: true, failedPayment: true);
    app.adapter.on('GET', ApiPaths.transactions, (_) => FakeReply(200, envelope({'list_transaction': []})));
    await app.pump(tester, location: '/dashboard');
    expect(find.text('3 konflik stok belum ditinjau'), findsOneWidget);
    expect(find.text('1 pembayaran QRIS/VA gagal atau kedaluwarsa hari ini'), findsOneWidget);
    expect(find.textContaining('Bu Sri'), findsOneWidget);
    await tester.tap(find.text('3 konflik stok belum ditinjau'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.last.queryParameters['open_conflict'], true);
  });

  testWidgets('quick action opens the add staff form', (tester) async {
    final app = CmsHarness();
    serveDashboard(app.adapter);
    app.adapter.on('GET', ApiPaths.users, (_) => FakeReply(200, envelope({'staff': []})));
    await app.pump(tester, location: '/dashboard');
    await tester.tap(find.widgetWithText(OutlinedButton, 'Tambah staff'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('dashboard fits a phone at 200% text', (tester) async {
    final app = CmsHarness();
    serveDashboard(app.adapter, conflicts: 1, oldDebt: true);
    await app.pump(tester, location: '/dashboard', size: const Size(360, 800), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('summary failure offers retry', (tester) async {
    final app = CmsHarness();
    serveDashboard(app.adapter);
    app.adapter.on('GET', ApiPaths.dashboard, (_) => FakeReply(500, errorBody('down')));
    await app.pump(tester, location: '/dashboard');
    expect(find.textContaining('Gagal memuat data'), findsOneWidget);
  });
}
