import 'package:core/core.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

import 'esc_pos.dart';

class BluetoothReceiptPrinter implements ReceiptPrinter {
  const BluetoothReceiptPrinter();

  @override
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings) async {
    final address = settings.printerAddress;
    if (address == null) return const Err(ValidationFailure('no_printer'));
    try {
      final ok = await FlutterBluetoothPrinter.printBytes(
        address: address,
        data: encodeReceipt(document),
        keepConnected: false,
      );
      return ok ? const Ok(null) : const Err(ServerFailure('print_failed'));
    } catch (e) {
      return Err(ServerFailure('print_failed: $e'));
    }
  }
}
