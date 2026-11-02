import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

// Real files from cwebp 1.x: gradients, no production data. webpinfo reports the sizes noted on each.
Uint8List _webp(String b64) => base64Decode(b64);



/// Lossy 33x33: an odd size, so width/height are not byte-aligned guesses.
final lossy33 = _webp(
  'UklGRqwAAABXRUJQVlA4IKAAAACwBgCdASohACEAPp1AmUmlpCKhONtsALATiWYAs7QFRagw/82s8p34Z8J8WnH2Z6elZ98H5hOAudxDOotdiAD++nIdGsEejOi4PKGQnEi39WxjdO388TnO3FII7FFu+zo4JmPb3Lg5mBqX0oU1A9jcbN+EeKQjZTZuw2YBBGCu9snDTOjTerjr7E3cAdWEf2qRGzA+0/f3YDQH1FL0IAAA',
);

/// Lossless 64x64 ('VP8L').
final lossless64 = _webp(
  'UklGRlgAAABXRUJQVlA4TEsAAAAvP8APAM1lRP9joahtI6b8EffGs4PCGRwGvP8T8ALtfvNW1LyGGpht2yRt4f+3ETNCCtI2YGG7EyEkIDggGQFsJN+MKc4fzff6bQ4A',
);

/// Lossless 90x120 (not square).
final lossless90x120 = _webp(
  'UklGRlQAAABXRUJQVlA4TEcAAAAvWcAdAM1lRP9jISRI+D/caC7EgPd/AqR+guK2bRwh2X/rfvfrCgEEQEETQTZp0+6SO4DYPJCKGVPiWFgaU25u6PsPff8hBgA=',
);

/// Extended 80x80 with alpha ('VP8X' + 'ALPH' + 'VP8 ').
final extended80 = _webp(
  'UklGRioBAABXRUJQVlA4WAoAAAAQAAAATwAATwAAQUxQSBwAAAABD/Cy/4iIICQgVjppqANKRP8JJmmq7RhCwxVOVlA4IOgAAADQBwCdASpQAFAAPrVSo063Oa8jJnM5mzAWiUDLYSAA/AP0A6P9z1IYgOn/jrgMksQ6hCPr////Jzf///5V3////Njf///zAAD+8O9WFFW/3B2w2KQdlf4DmVTGzqsv++LuH/oi042UTYZH0vw6TB+TKI5SR1r1Dq3FLsYW8jwGRo0bppa7AExKzhoeDhGqp9K0Mj/qhD1C9BfJEidLX50ZjA5HwLVXc0cTE+3ot0ZAnAQVMEQb/aoCsGUIsGlzyl3CiDg+wLFKbs8W0SlRuX0tdgCYksGNc8l4UDiE69WTCRvTHcP4c9AA',
);

void main() {
  group('webpSize reads the header of every WebP layout', () {
    for (final (name, bytes, w, h) in [
      ('lossy', square64, 64, 64),
      ('lossy wide', wide100x60, 100, 60),
      ('lossy odd', lossy33, 33, 33),
      ('lossless', lossless64, 64, 64),
      ('lossless tall', lossless90x120, 90, 120),
      ('extended with alpha', extended80, 80, 80),
    ]) {
      test(name, () {
        final size = ProductImage.webpSize(bytes);
        expect((size?.width, size?.height), (w, h));
      });
    }

    test('a header cut short is not a WebP', () {
      expect(ProductImage.webpSize(square64.sublist(0, 20)), isNull);
      expect(ProductImage.webpSize(const []), isNull);
    });

    test('PNG, JPEG, and a renamed text file are not WebP', () {
      final png = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, ...List.filled(40, 0)];
      final jpeg = [0xff, 0xd8, 0xff, 0xe0, ...List.filled(40, 0)];
      expect(ProductImage.webpSize(png), isNull);
      expect(ProductImage.webpSize(jpeg), isNull);
      expect(ProductImage.webpSize('RIFF....WAVEfmt '.codeUnits + List.filled(30, 0)), isNull);
    });
  });

  group('validate', () {
    test('a square WebP under 500 KB is valid', () {
      for (final b in [square64, lossy33, lossless64, extended80]) {
        expect(ProductImage.validate(b), isNull);
      }
    });

    test('other formats are rejected as not WebP', () {
      expect(ProductImage.validate([0x89, 0x50, 0x4e, 0x47, ...List.filled(40, 0)]), 'image_not_webp');
      expect(ProductImage.validate(const []), 'image_not_webp');
    });

    test('a WebP that is not 1:1 is rejected', () {
      expect(ProductImage.validate(wide100x60), 'image_not_square');
      expect(ProductImage.validate(lossless90x120), 'image_not_square');
    });

    test('size limit is 500 KB: the limit passes, one byte more fails', () {
      // Padding with trailing bytes keeps the header intact, so only the size rule can fire.
      Uint8List padded(int length) => Uint8List(length)..setRange(0, square64.length, square64);
      expect(ProductImage.validate(padded(500 * 1024)), isNull);
      expect(ProductImage.validate(padded(500 * 1024 + 1)), 'image_too_large');
    });

    test('format is checked before size, size before ratio', () {
      final bigPng = Uint8List(600 * 1024)..setRange(0, 4, [0x89, 0x50, 0x4e, 0x47]);
      expect(ProductImage.validate(bigPng), 'image_not_webp');
      Uint8List bigWide() => Uint8List(600 * 1024)..setRange(0, wide100x60.length, wide100x60);
      expect(ProductImage.validate(bigWide()), 'image_too_large');
    });
  });
}
