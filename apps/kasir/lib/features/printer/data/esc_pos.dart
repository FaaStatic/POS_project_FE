import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';

/// Minimal ESC/POS encoding for text receipts. Non-ASCII characters are replaced
/// because most cheap thermal printers only ship a Latin code page.
Uint8List encodeReceipt(ReceiptDocument document) {
  final out = BytesBuilder();
  const esc = 0x1B, gs = 0x1D;
  out.add([esc, 0x40]); // initialize
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
