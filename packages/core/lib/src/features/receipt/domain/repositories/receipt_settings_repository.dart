import '../entities/receipt_settings.dart';

abstract interface class ReceiptSettingsRepository {
  ReceiptSettings get current;
  Stream<ReceiptSettings> watch();
  Future<void> save(ReceiptSettings settings);
}
