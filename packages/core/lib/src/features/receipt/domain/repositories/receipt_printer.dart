import '../../../../common/result.dart';
import '../entities/receipt_document.dart';
import '../entities/receipt_settings.dart';

abstract interface class ReceiptPrinter {
  /// Fails with ValidationFailure('no_printer') when no printer is paired.
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings);
}
