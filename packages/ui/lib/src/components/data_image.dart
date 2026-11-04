import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart' show SvgPicture;

/// Decoded bytes by their base64 text, newest last. The same string comes back on every
/// rebuild of a list row, and a stable [Uint8List] lets Flutter's image cache hit instead of
/// decoding the picture again. 64 entries of at most 500 KB each is about 32 MB.
final _decoded = <String, Uint8List>{};
const _decodedLimit = 64;

// Anchored at the start: a base64 string is up to ~667 KB and has no "://" to find.
final _scheme = RegExp(r'^[a-z][a-z0-9+.-]*://', caseSensitive: false);

// Stands for "not base64" in the cache, so a lookup is one remove instead of a contains-check first;
// each lookup hashes the whole string, which for a new String instance is its full length.
final _notImage = Uint8List(0);

Uint8List? _bytesOf(String text) {
  final hit = _decoded.remove(text);
  if (hit != null) {
    _decoded[text] = hit;
    return identical(hit, _notImage) ? null : hit;
  }
  Uint8List? bytes;
  final comma = text.indexOf(',');
  final body = text.startsWith('data:') && comma > 0 ? text.substring(comma + 1) : text;
  try {
    // The backend stores plain padded base64, which the decoder reads directly. Cleaning a 500 KB string first
    // (three passes plus a copy) cost twenty times the decode itself, on the thread that draws the list.
    bytes = base64.decode(body);
  } on FormatException {
    try {
      // Another client may have stored the URL-safe alphabet, no padding, or lines wrapped at 76 columns;
      // none of that is part of the data.
      bytes = base64.decode(base64.normalize(body.replaceAll(RegExp(r'\s+'), '').replaceAll('-', '+').replaceAll('_', '/')));
    } on FormatException {
      // Not base64 (a stray path, free text): remembered as such so it is not retried on every build.
    }
  }
  _decoded[text] = bytes ?? _notImage;
  if (_decoded.length > _decodedLimit) _decoded.remove(_decoded.keys.first);
  return bytes;
}

/// What to draw for a stored product image: a URL is fetched, raw base64 (the backend stores
/// the string as sent) is decoded, anything else gives null so the caller shows a fallback.
/// [cacheWidth] decodes at display size instead of full pixels.
ImageProvider? imageProviderFor(String source, {int? cacheWidth}) {
  final text = source.trim();
  if (text.isEmpty) return null;
  final ImageProvider provider;
  if (text.startsWith(_scheme)) {
    // The browser keeps its own HTTP cache; elsewhere the file is kept on disk, so a list does not
    // download its pictures again after a restart.
    provider = kIsWeb ? NetworkImage(text) : CachedNetworkImageProvider(text);
  } else {
    final bytes = _bytesOf(text);
    if (bytes == null || bytes.isEmpty) return null;
    provider = MemoryImage(bytes);
  }
  return cacheWidth == null ? provider : ResizeImage(provider, width: cacheWidth);
}

/// Draws a stored product image. An SVG data URI (the backend seeds placeholder tiles this way)
/// goes through flutter_svg, because the bitmap decoder cannot read it; everything else goes
/// through [imageProviderFor]. Null when there is nothing to draw, and [fallback] replaces a
/// picture that fails to decode.
Widget? storedImageFor(String source, {int? cacheWidth, BoxFit fit = BoxFit.cover, required Widget fallback}) {
  final text = source.trim();
  if (text.startsWith('data:image/svg+xml')) {
    final bytes = _bytesOf(text);
    if (bytes == null || bytes.isEmpty) return null;
    return SvgPicture.memory(bytes, fit: fit, errorBuilder: (_, _, _) => fallback);
  }
  final provider = imageProviderFor(text, cacheWidth: cacheWidth);
  return provider == null ? null : Image(image: provider, fit: fit, errorBuilder: (_, _, _) => fallback);
}
