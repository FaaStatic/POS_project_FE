import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

void main() {
  testWidgets('debts: unpaid oldest first, pay with idempotency key, add manual credit', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({
            'transaction_list': [
              {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000, 'date_debt': '2026-09-01'},
            ],
          })))
      ..on('POST', ApiPaths.debtPay, (_) => FakeReply(200, envelope({'debt_id': 'd1', 'customer_name': 'Bu Sri', 'nominal_bayar': 5000, 'remaining_debt': 0, 'status': 'Lunas'})))
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'customer_lists': [
            {'id': 'k1', 'nama': 'Bu Sri', 'no_hp': '0812'},
          ]})))
      ..on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    await app.pump(tester, location: '/debts');
    expect(app.adapter.requests.firstWhere((r) => r.path == ApiPaths.debts).queryParameters, containsPair('order', 'asc'));
    expect(find.text('Bu Sri'), findsOneWidget);

    await tester.tap(find.byTooltip('Terima pembayaran'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Lunasi'));
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    final pay = app.adapter.requests.firstWhere((r) => r.path == ApiPaths.debtPay).data as Map;
    expect(pay['nominal_bayar'], 5000);
    expect(pay['idempotency_key'], isNotEmpty);
    expect(find.text('Pembayaran dicatat. Sisa Rp 0.'), findsOneWidget);
    await dismissInfo(tester);

    await tester.tap(find.widgetWithText(ShadButton, 'Tambah hutang manual'));
    await tester.pumpAndSettle();
    await tester.enterText(find.descendant(of: find.byType(ShadDialog), matching: find.byType(EditableText)).first, 'Bu');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bu Sri · 0812'));
    await tester.pumpAndSettle();
    await tester.enterText(find.descendant(of: find.byType(ShadDialog), matching: find.byType(EditableText)).at(1), '20000');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Hutang ditambahkan.'), findsOneWidget);
    await dismissInfo(tester);
    expect(app.adapter.requests.lastWhere((r) => r.method == 'POST' && r.path == ApiPaths.debts).data,
        {'customer_id': 'k1', 'total_transaksi': 20000});
  });

  testWidgets('the manual debt customer list opens on focus, without typing, and needs a pick', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({'transaction_list': []})))
      ..on('GET', ApiPaths.customers, (_) => FakeReply(200, envelope({'customer_lists': [
            {'id': 'k1', 'nama': 'Bu Sri', 'no_hp': '0812'},
          ]})))
      ..on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    await app.pump(tester, location: '/debts');
    await tester.tap(find.widgetWithText(ShadButton, 'Tambah hutang manual'));
    await tester.pumpAndSettle();
    // The dialog autofocuses the field, so the first customers are already listed.
    expect(find.text('Bu Sri · 0812'), findsOneWidget);

    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Wajib diisi'), findsOneWidget);
    expect(app.adapter.requests.where((r) => r.method == 'POST' && r.path == ApiPaths.debts), isEmpty);
  });

  testWidgets('adding to an existing debt: the form shows what is owed and what it becomes, and sends the note', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.debts, (_) => FakeReply(200, envelope({
            'transaction_list': [
              {'debt_id': 'd1', 'status': 'Belum Lunas', 'customer_id': 'k1', 'name_customer': 'Bu Sri', 'total_debt': 8000, 'remaining_debt': 5000, 'date_debt': '2026-09-01'},
            ],
          })))
      ..on('POST', ApiPaths.debts, (_) => FakeReply(201, envelope(null)));
    await app.pump(tester, location: '/debts');

    await tester.tap(find.byTooltip('Tambah hutang'));
    await tester.pumpAndSettle();
    expect(find.text('Hutang saat ini'), findsOneWidget);
    expect(find.textContaining('5.000'), findsWidgets);

    final inputs = find.descendant(of: find.byType(ShadDialog), matching: find.byType(EditableText));
    await tester.enterText(inputs.first, '20000');
    await tester.pumpAndSettle();
    expect(find.textContaining('Menjadi'), findsOneWidget);
    expect(find.textContaining('25.000'), findsOneWidget);

    await tester.enterText(inputs.last, 'Pinjam tunai');
    await tester.tap(find.widgetWithText(ShadButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Hutang ditambahkan.'), findsOneWidget);
    await dismissInfo(tester);
    expect(app.adapter.requests.lastWhere((r) => r.method == 'POST' && r.path == ApiPaths.debts).data,
        {'customer_id': 'k1', 'total_transaksi': 20000, 'note': 'Pinjam tunai'});
  });
}
