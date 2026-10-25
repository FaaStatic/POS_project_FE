/// Backend `type_payment`. Strings are used in request bodies, the index in
/// responses and list filters (tunai=0, hutang=1, transfer=2, qris=3).
/// VA charges settle as `transfer`.
enum PaymentMethod {
  cash('tunai'),
  debt('hutang'),
  va('transfer'),
  qris('qris');

  const PaymentMethod(this.wire);
  final String wire;

  static PaymentMethod fromIndex(int index) =>
      index >= 0 && index < values.length ? values[index] : PaymentMethod.cash;

  static PaymentMethod fromWire(String raw) =>
      values.firstWhere((m) => m.wire == raw.toLowerCase(), orElse: () => PaymentMethod.cash);

  /// Only cash and debt may be recorded without a connection.
  bool get worksOffline => this == cash || this == debt;
}

enum VaBank { bca, mandiri }
