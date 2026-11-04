import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';

/// A page with nothing happening must not ask for frames: a stray animation keeps rebuilding
/// and repainting while the cashier is idle.
void main() {
  testWidgets('the checkout product list schedules no frames while idle, even with more rows to load', (tester) async {
    final many = [
      for (var i = 0; i < 80; i++)
        Product(id: 'p$i', sku: 'SKU-$i', name: 'Produk $i', sellingPrice: 1000 + i, sellingPriceDebt: 1100 + i, stock: 10),
    ];
    final app = AppHarness(online: true)..serveBackend(products: many);
    await app.tokens.writeRefreshToken('r0');
    await app.pump(tester);
    await tester.pump(const Duration(seconds: 1));

    expect(tester.binding.hasScheduledFrame, isFalse, reason: 'something keeps animating');
    await tester.runAsync(app.close);
  });
}
