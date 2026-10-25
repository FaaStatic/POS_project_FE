import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

enum PaymentState {
  pending,
  settling,
  success,
  failed,
  expired;

  static PaymentState parse(String raw) =>
      values.firstWhere((s) => s.name == raw.toLowerCase(), orElse: () => PaymentState.pending);

  bool get isFinal => this == success || this == failed || this == expired;
}

enum ChargeMethod { qris, va }

/// QRIS/VA charge created from the kasir.
@freezed
abstract class Charge with _$Charge {
  const factory Charge({
    required String orderId,
    required ChargeMethod method,
    required PaymentState state,
    required int grossAmount,
    String? qrString,
    String? qrUrl,
    String? vaNumber,
    String? bank,
    String? billKey,
    String? billerCode,
    DateTime? expiresAt,
  }) = _Charge;
}

@freezed
abstract class ChargeStatus with _$ChargeStatus {
  const factory ChargeStatus({
    required String orderId,
    required PaymentState state,
    required int grossAmount,
    String? transactionId,
    DateTime? paidAt,
  }) = _ChargeStatus;
}

/// Row in the CMS payment monitor.
@freezed
abstract class PaymentRecord with _$PaymentRecord {
  const factory PaymentRecord({
    required String id,
    required String orderId,
    required ChargeMethod method,
    required PaymentState state,
    required int grossAmount,
    @Default(0) int feeAmount,
    String? midtransStatus,
    String? vaBank,
    String? vaNumber,
    String? transactionId,
    DateTime? expiresAt,
    DateTime? paidAt,
    DateTime? createdAt,
  }) = _PaymentRecord;
}

class ChargeItem {
  const ChargeItem(this.productId, this.qty);
  final String productId;
  final double qty;
}

class PaymentQuery {
  const PaymentQuery({this.state, this.method, this.dateStart, this.dateEnd, this.limit = 20});
  final PaymentState? state;
  final ChargeMethod? method;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int limit;
}
