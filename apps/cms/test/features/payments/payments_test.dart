import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

void main() {
  testWidgets('payments: status filter, method filter, check status', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.payments, (_) => FakeReply(200, envelope({
            'payments': [
              {'id': 'x', 'order_id': 'ORD-1', 'method': 'qris', 'status': 'pending', 'gross_amount': 7070, 'fee_amount': 70, 'created_at': '2026-10-25T08:00:00Z'},
            ],
          })))
      ..on('GET', ApiPaths.paymentStatus('ORD-1'), (_) => FakeReply(200, envelope({'order_id': 'ORD-1', 'status': 'success', 'gross_amount': 7070})));
    await app.pump(tester, location: '/payments');
    expect(find.text('ORD-1'), findsOneWidget);
    expect(find.text('Menunggu'), findsOneWidget);
    await tester.tap(find.text('Cek status'));
    await tester.pumpAndSettle();
    expect(find.text('Status terbaru: Berhasil'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(AppTabs<ChargeMethod?>), matching: find.text('VA')));
    await tester.pumpAndSettle();
    expect(app.adapter.requests.last.queryParameters['method'], 'va');
  });
}
