import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/printer/data/esc_pos.dart';
import 'package:kasir/features/printer/presentation/bloc/receipt_settings_cubit.dart';

void main() {
  test('saves trimmed store info and emits it', () async {
    final repo = ReceiptSettingsRepositoryImpl(MemoryStore());
    final cubit = ReceiptSettingsCubit(GetReceiptSettings(repo), SaveReceiptSettings(repo))..start();
    expect(cubit.state.paper, PaperWidth.mm58);
    await Future<void>.delayed(Duration.zero);
    final next = cubit.stream.firstWhere((s) => s.storeName == 'Toko Maju');
    await cubit.save(const ReceiptSettings(storeName: ' Toko Maju ', paper: PaperWidth.mm80, printerAddress: 'AA:BB'));
    final s = await next;
    expect(s.paper, PaperWidth.mm80);
    expect(repo.current.printerName, 'AA:BB');
    await cubit.save(s.copyWith(printerAddress: null));
    expect(repo.current.printerAddress, isNull);
    await cubit.close();
  });

  test('PrintReceipt refuses without a paired printer', () async {
    final repo = ReceiptSettingsRepositoryImpl(MemoryStore());
    final r = await PrintReceipt(_NoopPrinter(), repo)(ReceiptDocument(const []));
    expect(r, const Err<void>(ValidationFailure('no_printer')));
  });

  test('ESC/POS output starts with init, ends with cut, and strips non-ASCII', () {
    final bytes = encodeReceipt(ReceiptDocument(const [ReceiptLine('Kopi → Rp 3.000', bold: true, align: ReceiptAlign.center)]));
    expect(bytes.take(2), [0x1B, 0x40]);
    expect(bytes.skip(bytes.length - 4), [0x1D, 0x56, 0x42, 0x00]);
    expect(String.fromCharCodes(bytes), contains('Kopi -> Rp 3.000'));
  });
}

class _NoopPrinter implements ReceiptPrinter {
  @override
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings) async => const Ok(null);
}
