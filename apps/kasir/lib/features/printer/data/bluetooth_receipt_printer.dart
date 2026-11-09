import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:ui/ui.dart' show brandMarkBitmap;

import 'esc_pos.dart';

final _logos = <int, Uint8List>{};

/// The app mark as an ESC/POS raster [widthDots] wide, rendered once. Null when it cannot be
/// drawn, so the slip still prints without it.
Future<Uint8List?> printableLogo(int widthDots) async {
  final cached = _logos[widthDots];
  if (cached != null) return cached;
  final bitmap = await brandMarkBitmap(widthDots);
  return bitmap == null ? null : _logos[widthDots] = rasterImage(bitmap.rgba, bitmap.width, bitmap.height);
}

class BluetoothReceiptPrinter implements ReceiptPrinter {
  const BluetoothReceiptPrinter();

  @override
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings) async {
    final address = settings.printerAddress;
    if (address == null) return const Err(ValidationFailure('no_printer'));
    try {
      final ok = await FlutterBluetoothPrinter.printBytes(
        address: address,
        data: encodeReceipt(document, logo: await printableLogo(settings.paper == PaperWidth.mm80 ? 128 : 96)),
        keepConnected: false,
      );
      return ok ? const Ok(null) : const Err(ServerFailure('print_failed'));
    } catch (e) {
      return Err(ServerFailure('print_failed: $e'));
    }
  }
}
