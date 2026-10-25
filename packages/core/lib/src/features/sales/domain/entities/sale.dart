import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/payment_method.dart';

part 'sale.freezed.dart';

enum SaleStatus { pending, synced, failed, cancelled }

@freezed
abstract class SaleLine with _$SaleLine {
  const SaleLine._();

  const factory SaleLine({
    required String productId,
    required String name,
    required double qty,
    required int unitPrice,
    String? destination,
  }) = _SaleLine;

  int get subtotal => (qty * unitPrice).round();
}

/// A sale recorded on this device. Offline sales start `pending` with a temporary
/// receipt number; online and synced sales carry the server invoice.
@freezed
abstract class Sale with _$Sale {
  const Sale._();

  const factory Sale({
    required String clientRef,
    required String receiptNumber,
    required DateTime createdAt,
    required PaymentMethod method,
    String? customerId,
    String? customerName,
    required String cashierName,
    required int total,
    required List<SaleLine> lines,
    @Default(SaleStatus.pending) SaleStatus status,
    String? error,
    String? transactionId,
    @Default(false) bool stockConflict,
    String? cancelReason,
  }) = _Sale;

  bool get isSynced => status == SaleStatus.synced;
  bool get isOffline => receiptNumber.startsWith('OFF-');
}
