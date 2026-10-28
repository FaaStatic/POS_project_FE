import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

void main() {
  testWidgets('devices: platform filter and revoke with confirmation', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.devices, (o) => FakeReply(200, envelope([
            if (o.queryParameters['platform'] != 'ios')
              {'id': 'd1', 'device_id': 'kasir-1', 'platform': 'android', 'username': 'kasir1', 'last_used_at': '2026-10-25T08:00:00Z'},
          ])))
      ..on('DELETE', ApiPaths.device('d1'), (_) => FakeReply(200, envelope(null)));
    await app.pump(tester, location: '/devices');
    expect(find.text('kasir1'), findsOneWidget);
    await tester.tap(find.widgetWithText(ShadButton, 'Cabut'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ShadButton, 'Cabut').last);
    await tester.pumpAndSettle();
    expect(find.text('Device dicabut.'), findsOneWidget);
    await tester.tap(find.text('iOS'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada device yang login.'), findsOneWidget);
    expect(app.adapter.requests.last.queryParameters, {'platform': 'ios'});
  });

  testWidgets('devices error state', (tester) async {
    final app = CmsHarness();
    app.adapter.on('GET', ApiPaths.devices, (_) => FakeReply(500, errorBody('down')));
    await app.pump(tester, location: '/devices');
    expect(find.textContaining('Gagal memuat data'), findsOneWidget);
  });
}
