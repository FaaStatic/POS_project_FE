/// Pixel size of a WebP, read from its header without decoding.
typedef WebpSize = ({int width, int height});

/// Rules for a product picture, checked before upload so the error shows before a round trip.
/// The backend re-checks the format and size, shrinks the picture to 256 px, and refuses sources
/// over 16 million pixels. Error keys follow [Validators].
abstract final class ProductImage {
  /// 500 KB, counted in KiB like the file sizes the OS shows.
  static const maxBytes = 500 * 1024;

  /// Longest side accepted; 4000 x 4000 is exactly the backend's 16 million pixel limit.
  static const maxSide = 4000;

  /// Null when [bytes] is not a WebP or its header is cut short.
  ///
  /// RIFF layout (developers.google.com/speed/webp/docs/riff_container): 'RIFF', size, 'WEBP',
  /// then the first chunk at byte 12 with its payload from byte 20. The three image layouts
  /// keep the size in different places; offsets were checked against files from cwebp.
  static WebpSize? webpSize(List<int> bytes) {
    if (bytes.length < 30 || !_is(bytes, 0, 'RIFF') || !_is(bytes, 8, 'WEBP')) return null;
    int u16(int o) => bytes[o] | bytes[o + 1] << 8;
    int u24(int o) => u16(o) | bytes[o + 2] << 16;

    if (_is(bytes, 12, 'VP8X')) {
      // Canvas width and height minus one, 24 bits each, after 4 bytes of flags.
      return (width: 1 + u24(24), height: 1 + u24(27));
    }
    if (_is(bytes, 12, 'VP8L')) {
      // Signature 0x2f, then width-1 and height-1 as 14 bits each.
      if (bytes[20] != 0x2f) return null;
      final bits = u24(21) | bytes[24] << 24;
      return (width: 1 + (bits & 0x3fff), height: 1 + ((bits >> 14) & 0x3fff));
    }
    if (_is(bytes, 12, 'VP8 ')) {
      // Key frame: 3-byte tag, start code 9d 01 2a, then 14-bit width and height (top 2 bits are scaling).
      if (bytes[23] != 0x9d || bytes[24] != 0x01 || bytes[25] != 0x2a) return null;
      return (width: u16(26) & 0x3fff, height: u16(28) & 0x3fff);
    }
    return null;
  }

  /// Null when valid, else `image_not_webp`, `image_too_large`, `image_not_square`, or
  /// `image_dimensions`, checked in that order so the most basic problem is reported first.
  static String? validate(List<int> bytes) {
    final size = webpSize(bytes);
    if (size == null) return 'image_not_webp';
    if (bytes.length > maxBytes) return 'image_too_large';
    if (size.width != size.height) return 'image_not_square';
    return size.width > maxSide ? 'image_dimensions' : null;
  }

  static bool _is(List<int> b, int offset, String text) {
    for (var i = 0; i < text.length; i++) {
      if (b[offset + i] != text.codeUnitAt(i)) return false;
    }
    return true;
  }
}
