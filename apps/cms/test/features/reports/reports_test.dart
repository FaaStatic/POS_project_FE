import 'package:cms/common/file_saver.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../../helpers/cms_harness.dart';

void main() {
  testWidgets('downloads the monthly PDF for the chosen month', (tester) async {
    final app = CmsHarness();
    app.adapter
      ..on('GET', ApiPaths.reportMonth, (_) => FakeReply(200, envelope({'url_pdf': '/api/reports/2026-10.pdf'})))
      ..on('GET', '/api/reports/2026-10.pdf', (_) => const FakeReply(200, [37, 80]));
    await app.pump(tester, location: '/reports');
    await tester.tap(find.widgetWithText(ShadButton, 'Unduh PDF'));
    await tester.pumpAndSettle();
    expect(savedFiles.last, '2026-10.pdf');
    expect(find.text('File diunduh.'), findsOneWidget);
    final now = DateTime.now();
    expect(app.adapter.requests.firstWhere((r) => r.path == ApiPaths.reportMonth).queryParameters, {'month': now.month, 'year': now.year});
  });

  testWidgets('report failure is shown', (tester) async {
    final app = CmsHarness();
    app.adapter.on('GET', ApiPaths.reportMonth, (_) => FakeReply(500, errorBody('pdf failed')));
    await app.pump(tester, location: '/reports', size: const Size(390, 800));
    await tester.tap(find.widgetWithText(ShadButton, 'Unduh PDF'));
    await tester.pumpAndSettle();
    expect(find.text('pdf failed'), findsOneWidget);
  });
}
