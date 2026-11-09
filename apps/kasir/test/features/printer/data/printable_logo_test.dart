import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/printer/data/bluetooth_receipt_printer.dart';

void main() {
  testWidgets('the brand mark becomes a square GS v 0 raster of the asked width, mostly ink', (tester) async {
    final raster = await tester.runAsync(() => printableLogo(96));
    expect(raster, isNotNull);
    // 96 dots = 12 bytes per row, 96 rows (the mark is square).
    expect(raster!.sublist(0, 8), [0x1D, 0x76, 0x30, 0, 12, 0, 96, 0]);
    expect(raster.length, 8 + 12 * 96);
    final ink = raster.skip(8).fold<int>(0, (n, b) => n + b.toRadixString(2).replaceAll('0', '').length);
    // A filled blue square with a white M: well over a third of the dots print, never all of them.
    expect(ink, inInclusiveRange(96 * 96 ~/ 3, 96 * 96 - 1));
  });
}
