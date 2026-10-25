import 'dart:async';

import '../../../storage/key_value_store.dart';
import '../domain/entities/receipt_settings.dart';
import '../domain/repositories/receipt_settings_repository.dart';

class ReceiptSettingsRepositoryImpl implements ReceiptSettingsRepository {
  ReceiptSettingsRepositoryImpl(this._store);

  final KeyValueStore _store;
  final _changes = StreamController<ReceiptSettings>.broadcast();

  @override
  ReceiptSettings get current => ReceiptSettings(
        storeName: _store.getString('store_name') ?? '',
        storeAddress: _store.getString('store_address') ?? '',
        footer: _store.getString('store_footer') ?? '',
        paper: _store.getString('paper_width') == PaperWidth.mm80.name ? PaperWidth.mm80 : PaperWidth.mm58,
        autoPrint: _store.getBool('auto_print') ?? false,
        printerAddress: _store.getString('printer_address'),
        printerName: _store.getString('printer_name'),
      );

  @override
  Stream<ReceiptSettings> watch() async* {
    yield current;
    yield* _changes.stream;
  }

  @override
  Future<void> save(ReceiptSettings s) async {
    await _store.setString('store_name', s.storeName);
    await _store.setString('store_address', s.storeAddress);
    await _store.setString('store_footer', s.footer);
    await _store.setString('paper_width', s.paper.name);
    await _store.setBool('auto_print', s.autoPrint);
    if (s.printerAddress == null) {
      await _store.remove('printer_address');
      await _store.remove('printer_name');
    } else {
      await _store.setString('printer_address', s.printerAddress!);
      await _store.setString('printer_name', s.printerName ?? s.printerAddress!);
    }
    _changes.add(current);
  }
}
