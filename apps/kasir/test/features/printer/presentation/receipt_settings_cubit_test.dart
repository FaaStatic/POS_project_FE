import 'dart:typed_data';

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

  test('raster logo: GS v 0 header, 1 bit per pixel, dark opaque pixels print, transparent ones stay blank', () {
    // 10 x 2: row 0 all black, row 1 black only at x = 0; one transparent pixel in row 0.
    final rgba = Uint8List(10 * 2 * 4);
    for (var i = 0; i < 20; i++) {
      final dark = i < 10 || i == 10;
      rgba.setRange(i * 4, i * 4 + 4, dark ? [0, 0, 0, 255] : [255, 255, 255, 255]);
    }
    rgba[9 * 4 + 3] = 0; // x = 9 of row 0 is transparent
    final raster = rasterImage(rgba, 10, 2);
    expect(raster.sublist(0, 8), [0x1D, 0x76, 0x30, 0, 2, 0, 2, 0]);
    expect(raster.sublist(8), [0xFF, 0x80, 0x80, 0x00]);
  });

  test('a logo is centered and printed before the first line', () {
    final logo = Uint8List.fromList([1, 2, 3]);
    final bytes = encodeReceipt(ReceiptDocument(const [ReceiptLine('Toko')]), logo: logo);
    expect(bytes.sublist(0, 2 + 3 + 3), [0x1B, 0x40, 0x1B, 0x61, 1, 1, 2, 3]);
    expect(encodeReceipt(ReceiptDocument(const [ReceiptLine('Toko')])).sublist(0, 5), [0x1B, 0x40, 0x1B, 0x61, 0]);
  });
}

class _NoopPrinter implements ReceiptPrinter {
  @override
  Future<Result<void>> print(ReceiptDocument document, ReceiptSettings settings) async => const Ok(null);
}
