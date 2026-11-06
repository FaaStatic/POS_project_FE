import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/tablet_layout.dart';

import '../helpers/app_harness.dart';

void main() {
  const sizes = {'phone': Size(360, 780), 'tablet': Size(800, 1280), 'landscape': Size(1280, 800)};

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('$name shows the floating bar and no rail', (tester) async {
      final app = AppHarness(online: true)..serveBackend();
      await app.tokens.writeRefreshToken('r0');
      await app.pump(tester, size: size);

      expect(find.byType(NavigationRail), findsNothing);
      final bar = tester.getSize(find.byType(NavigationBar));
      // On a tablet the checkout keeps the order panel on the right; the pill floats in the catalog column.
      final column = checkoutBeside(size) ? size.width - checkoutPanelWidth(size.width) : size.width;
      if (column < 600) {
        expect(bar.width, column - 24);
      } else {
        expect(bar.width, closeTo((column * 0.6).clamp(360, 560), 1));
      }
      expect(tester.getRect(find.byType(NavigationBar)).right, lessThanOrEqualTo(column));
      await tester.runAsync(app.close);
    });
  }

  testWidgets('the pill keeps its own height under a status bar inset and does not cover the page', (tester) async {
    final app = AppHarness(online: true)..serveBackend();
    await app.tokens.writeRefreshToken('r0');
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
    await app.pump(tester, size: const Size(390, 844));

    final bar = tester.getRect(find.byType(NavigationBar));
    expect(bar.height, 68, reason: 'the status bar inset must not stretch the pill');
    expect(tester.getRect(find.byType(Scaffold).last).bottom, lessThanOrEqualTo(bar.top + 0.5), reason: 'the page ends above the pill');
    await tester.runAsync(app.close);
  });
}
