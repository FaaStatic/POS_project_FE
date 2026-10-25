import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../entities/receipt_document.dart';
import '../entities/receipt_settings.dart';
import '../repositories/receipt_printer.dart';
import '../repositories/receipt_settings_repository.dart';

class GetReceiptSettings {
  const GetReceiptSettings(this._repo);
  final ReceiptSettingsRepository _repo;

  ReceiptSettings call() => _repo.current;
  Stream<ReceiptSettings> watch() => _repo.watch();
}

class SaveReceiptSettings {
  const SaveReceiptSettings(this._repo);
  final ReceiptSettingsRepository _repo;

  Future<void> call(ReceiptSettings settings) => _repo.save(settings.copyWith(
        storeName: settings.storeName.trim(),
        storeAddress: settings.storeAddress.trim(),
        footer: settings.footer.trim(),
      ));
}

class PrintReceipt {
  const PrintReceipt(this._printer, this._settings);
  final ReceiptPrinter _printer;
  final ReceiptSettingsRepository _settings;

  Future<Result<void>> call(ReceiptDocument document) {
    final settings = _settings.current;
    if (settings.printerAddress == null) return Future.value(const Err(ValidationFailure('no_printer')));
    return _printer.print(document, settings);
  }
}
