import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

/// A real 1x1 PNG, so a decode in a widget test succeeds.
const _png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg==';

void main() {
  group('BarcodeImage', () {
    for (final entry in {'raw base64 as the backend sends it': _png, 'a data URI': 'data:image/png;base64,$_png'}.entries) {
      testWidgets('draws ${entry.key}', (tester) async {
        await pumpUi(tester, BarcodeImage(image: entry.value, semanticLabel: 'Barcode'));
        expect(find.byType(Image), findsOneWidget);
      });
    }

    for (final entry in {'empty': '', 'not base64': 'SKU-1-1a2b3c4d.png'}.entries) {
      testWidgets('draws nothing for ${entry.key}', (tester) async {
        await pumpUi(tester, BarcodeImage(image: entry.value, semanticLabel: 'Barcode'));
        expect(find.byType(Image), findsNothing);
      });
    }
  });
}
