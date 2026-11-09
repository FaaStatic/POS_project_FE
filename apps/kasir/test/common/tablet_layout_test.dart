import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/tablet_layout.dart';

void main() {
  test('the order sits beside the catalog on tablets and not on phones turned sideways', () {
    expect(checkoutBeside(const Size(360, 780)), isFalse);
    expect(
      checkoutBeside(const Size(844, 390)),
      isFalse,
      reason: 'phone landscape under 900 keeps the cart sheet',
    );
    expect(
      checkoutBeside(const Size(800, 1280)),
      isTrue,
      reason: 'portrait tablet',
    );
    expect(checkoutBeside(const Size(1280, 800)), isTrue);
    expect(
      checkoutBeside(const Size(932, 430)),
      isTrue,
      reason: 'wide phone landscape was already side by side',
    );
  });

  test(
    'the panel keeps 380 and 420 on landscape tablets and narrows below 900',
    () {
      expect(checkoutPanelWidth(800), 320);
      expect(checkoutPanelWidth(1000), 380);
      expect(checkoutPanelWidth(1280), 420);
    },
  );
}
