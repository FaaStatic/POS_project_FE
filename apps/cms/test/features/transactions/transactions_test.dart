import 'package:cms/common/file_saver.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cms_harness.dart';

Map<String, dynamic> trx({bool conflict = true, bool reviewed = false}) => {
      'transaction_id': 't1',
      'invoice_number': 'INV-001',
      'payment_type': 0,
      'total_transaction': 7000,
      'total_profit': 2000,
      'stock_conflict': conflict,
      'conflict_reviewed': reviewed,
      'created_at': '2026-10-25T08:00:00Z',
      'transaction_details': [
        {'product_id': 'p1', 'product_name': 'Indomie', 'price': 3500, 'qty': 2, 'subtotal': 7000},
      ],
    };

void main() {
  testWidgets('list filters by conflict and method; detail reviews, downloads, cancels', (tester) async {
    final app = CmsHarness();
    var reviewed = false;
    app.adapter
      ..on('GET', ApiPaths.transactions, (_) => FakeReply(200, envelope({'list_transaction': [trx(reviewed: reviewed)]})))
      ..on('GET', ApiPaths.transaction('t1'), (_) => FakeReply(200, envelope(trx(reviewed: reviewed))))
      ..on('PATCH', ApiPaths.transactionConflictReview('t1'), (_) {
        reviewed = true;
        return FakeReply(200, envelope(null));
      })
      ..on('GET', ApiPaths.reportTransaction, (_) => FakeReply(200, envelope({'url_pdf': '/api/reports/inv-001.pdf'})))
      ..on('GET', '/api/reports/inv-001.pdf', (_) => const FakeReply(200, [37, 80]))
      ..on('DELETE', ApiPaths.transaction('t1'), (_) => FakeReply(200, envelope(null)));
    await app.pump(tester, location: '/transactions');
    expect(find.text('INV-001'), findsOneWidget);
    expect(find.text('Konflik stok'), findsWidgets);

    await tester.tap(find.widgetWithText(FilterChip, 'Konflik stok'));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.last.queryParameters['open_conflict'], true);

    await tester.tap(find.text('INV-001'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Tandai sudah ditinjau'));
    await tester.pumpAndSettle();
    expect(find.text('Ditandai sudah ditinjau.'), findsOneWidget);
    expect(find.text('Sudah ditinjau'), findsOneWidget);

    await tester.tap(find.text('Unduh struk PDF'));
    await tester.pumpAndSettle();
    expect(savedFiles.last, 'inv-001.pdf');

    await tester.tap(find.text('Batalkan transaksi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'salah input');
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.widgetWithText(FilledButton, 'Batalkan transaksi')));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.last.data, {'trx_id': 't1', 'reason': 'salah input'});
    expect(find.text('INV-001'), findsOneWidget);
  });

  testWidgets('conflicts link from the dashboard opens the filtered list', (tester) async {
    final app = CmsHarness();
    app.adapter.on('GET', ApiPaths.transactions, (_) => FakeReply(200, envelope({'list_transaction': []})));
    await app.pump(tester, location: '/transactions?conflicts=1', size: const Size(400, 800));
    expect(app.adapter.requests.last.queryParameters['open_conflict'], true);
    expect(find.text('Belum ada transaksi pada filter ini.'), findsOneWidget);
  });
}
