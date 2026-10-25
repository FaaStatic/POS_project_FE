import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_settings.freezed.dart';

enum PaperWidth {
  mm58(32),
  mm80(48);

  const PaperWidth(this.chars);

  /// Characters per line in the printer's default font.
  final int chars;
}

/// Device-local store details and printer preferences for receipts.
@freezed
abstract class ReceiptSettings with _$ReceiptSettings {
  const factory ReceiptSettings({
    @Default('') String storeName,
    @Default('') String storeAddress,
    @Default('') String footer,
    @Default(PaperWidth.mm58) PaperWidth paper,
    @Default(false) bool autoPrint,
    String? printerAddress,
    String? printerName,
  }) = _ReceiptSettings;
}
