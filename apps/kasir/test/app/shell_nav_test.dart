import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
      if (size.width < 600) {
        expect(bar.width, size.width - 24);
      } else {
        expect(bar.width, closeTo((size.width * 0.6).clamp(360, 560), 1));
      }
      await tester.runAsync(app.close);
    });
  }
}
