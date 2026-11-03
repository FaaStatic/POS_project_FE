import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/painting.dart';

/// Decoded bytes by their base64 text, newest last. The same string comes back on every
/// rebuild of a list row, and a stable [Uint8List] lets Flutter's image cache hit instead of
/// decoding the picture again. 64 entries of at most 500 KB each is about 32 MB.
final _decoded = <String, Uint8List?>{};
const _decodedLimit = 64;

// Anchored at the start: a base64 string is up to ~667 KB and has no "://" to find.
final _scheme = RegExp(r'^[a-z][a-z0-9+.-]*://', caseSensitive: false);

Uint8List? _bytesOf(String text) {
  if (_decoded.containsKey(text)) {
    final bytes = _decoded.remove(text);
    _decoded[text] = bytes;
    return bytes;
  }
  Uint8List? bytes;
  try {
    // Another client may have stored a data URI, the URL-safe alphabet, no padding, or lines wrapped
    // at 76 columns; none of that is part of the data.
    final comma = text.indexOf(',');
    final body = text.startsWith('data:') && comma > 0 ? text.substring(comma + 1) : text;
    bytes = base64.decode(
      base64.normalize(body.replaceAll(RegExp(r'\s+'), '').replaceAll('-', '+').replaceAll('_', '/')),
    );
  } on FormatException {
    // Not base64 (a stray path, free text): remembered as such so it is not retried on every build.
  }
  _decoded[text] = bytes;
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
    provider = NetworkImage(text);
  } else {
    final bytes = _bytesOf(text);
    if (bytes == null || bytes.isEmpty) return null;
    provider = MemoryImage(bytes);
  }
  return cacheWidth == null ? provider : ResizeImage(provider, width: cacheWidth);
}
