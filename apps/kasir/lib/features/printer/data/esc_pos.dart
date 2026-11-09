import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';

/// Minimal ESC/POS encoding for text receipts. Non-ASCII characters are replaced
/// because most cheap thermal printers only ship a Latin code page.
///
/// [logo] is a [rasterImage], printed centered above the first line.
Uint8List encodeReceipt(ReceiptDocument document, {Uint8List? logo}) {
  final out = BytesBuilder();
  const esc = 0x1B, gs = 0x1D;
  out.add([esc, 0x40]); // initialize
  if (logo != null) {
    out.add([esc, 0x61, 1]);
    out.add(logo);
    out.addByte(0x0A);
  }
  for (final line in document.lines) {
    out.add([esc, 0x61, line.align == ReceiptAlign.center ? 1 : 0]);
    out.add([esc, 0x45, line.bold ? 1 : 0]);
    out.add(latin1.encode(_ascii(line.text)));
    out.addByte(0x0A);
  }
  out.add([esc, 0x45, 0, esc, 0x61, 0]);
  out.add([0x0A, 0x0A, 0x0A]);
  out.add([gs, 0x56, 0x42, 0x00]); // partial cut, ignored by printers without a cutter
  return out.toBytes();
}

String _ascii(String s) => s.replaceAll('→', '->').replaceAll(RegExp(r'[^\x20-\x7E\n]'), '?');

/// `GS v 0` raster of an RGBA bitmap: one bit per pixel, 1 prints. A pixel is dark when it is opaque
/// and its luminance is under half; transparent pixels stay paper.
Uint8List rasterImage(Uint8List rgba, int width, int height) {
  final rowBytes = (width + 7) ~/ 8;
  final out = Uint8List(8 + rowBytes * height);
  out.setAll(0, [0x1D, 0x76, 0x30, 0, rowBytes & 0xFF, rowBytes >> 8, height & 0xFF, height >> 8]);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final i = (y * width + x) * 4;
      final luminance = (rgba[i] * 299 + rgba[i + 1] * 587 + rgba[i + 2] * 114) ~/ 1000;
      if (rgba[i + 3] >= 128 && luminance < 128) out[8 + y * rowBytes + (x >> 3)] |= 0x80 >> (x & 7);
    }
  }
  return out;
}
