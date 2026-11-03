import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_line.freezed.dart';

/// Backend `change[].kind`. Candy and other goods are priced by the server from
/// the product's selling price; the app computes the same value to check the sum.
enum ChangeKind {
  cash('tunai'),
  candy('permen'),
  product('produk_lain');

  const ChangeKind(this.wire);
  final String wire;
}

/// One part of the change handed back: money, candy, or another physical product.
@freezed
abstract class ChangeLine with _$ChangeLine {
  const ChangeLine._();

  const factory ChangeLine({
    required ChangeKind kind,

    /// Rupiah value of this line.
    required int amount,
    String? productId,
    @Default('') String productName,
    @Default(0) double qty,

    /// The product is sold in pieces, so [qty] must be whole.
    @Default(true) bool wholeOnly,
  }) = _ChangeLine;

  factory ChangeLine.cash(int amount) => ChangeLine(kind: ChangeKind.cash, amount: amount);

  factory ChangeLine.goods({
    required ChangeKind kind,
    required String productId,
    required String productName,
    required double qty,
    required int unitPrice,
    required bool wholeOnly,
  }) => ChangeLine(
    kind: kind,
    amount: (qty * unitPrice).round(),
    productId: productId,
    productName: productName,
    qty: qty,
    wholeOnly: wholeOnly,
  );

  bool get isCash => kind == ChangeKind.cash;
}
