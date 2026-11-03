import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

/// A real 1x1 PNG, so a decode in a widget test succeeds.
const _png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg==';

void main() {
  group('imageProviderFor tells a URL from stored base64', () {
    test('http and https are fetched as before', () {
      expect(imageProviderFor('https://cdn.example.com/a.png'), isA<NetworkImage>());
      expect(imageProviderFor('http://cdn.example.com/a.png'), isA<NetworkImage>());
    });

    test('raw base64, with or without line wraps, becomes memory bytes', () {
      expect(imageProviderFor(_png), isA<MemoryImage>());
      expect(imageProviderFor('${_png.substring(0, 20)}\n${_png.substring(20)}'), isA<MemoryImage>());
    });

    test('a data URI, URL-safe letters, or missing padding still decode to the same bytes', () {
      final expected = base64Decode(_png);
      final urlSafe = _png.replaceAll('+', '-').replaceAll('/', '_');
      final unpadded = _png.replaceAll('=', '');
      for (final text in ['data:image/png;base64,$_png', 'data:image/webp;base64,$unpadded', urlSafe, unpadded]) {
        expect((imageProviderFor(text) as MemoryImage).bytes, expected, reason: text);
      }
    });

    test('the bytes are what the base64 holds', () {
      final provider = imageProviderFor(_png) as MemoryImage;
      expect(provider.bytes, base64Decode(_png));
    });

    test('the same string reuses the decoded bytes, so the image cache can hit', () {
      final a = imageProviderFor(_png) as MemoryImage;
      final b = imageProviderFor(_png) as MemoryImage;
      expect(identical(a.bytes, b.bytes), isTrue);
    });

    test('empty, blank, and text that is not base64 give nothing to draw', () {
      expect(imageProviderFor(''), isNull);
      expect(imageProviderFor('   '), isNull);
      expect(imageProviderFor('not an image!'), isNull);
      expect(imageProviderFor('/uploads/a.png'), isNull);
    });

    test('cacheWidth resizes the decode instead of keeping full pixels', () {
      expect(imageProviderFor(_png, cacheWidth: 48), isA<ResizeImage>());
    });
  });

  group('InitialAvatar', () {
    testWidgets('draws stored base64 as an image', (tester) async {
      await pumpUi(tester, const InitialAvatar(name: 'Indomie Goreng', imageUrl: _png));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('falls back to initials when the string is not an image', (tester) async {
      await pumpUi(tester, const InitialAvatar(name: 'Indomie Goreng', imageUrl: 'not an image!'));
      expect(find.byType(Image), findsNothing);
      expect(find.text('IG'), findsOneWidget);
    });

    testWidgets('falls back to initials when there is no image', (tester) async {
      await pumpUi(tester, const InitialAvatar(name: 'Aqua 600ml'));
      expect(find.text('AQ'), findsOneWidget);
    });
  });
}
