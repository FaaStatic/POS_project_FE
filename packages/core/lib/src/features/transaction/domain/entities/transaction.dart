import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/payment_method.dart';

part 'transaction.freezed.dart';

@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String productId,
    required String name,
    required int price,
    required double qty,
    required int subtotal,
  }) = _TransactionItem;
}

/// Server transaction. The backend response carries no cashier, customer, or
/// destination; callers that need them keep their own copy.
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String invoice,
    required PaymentMethod method,
    required int total,
    @Default(0) int profit,
    @Default(false) bool stockConflict,
    @Default(false) bool conflictReviewed,
    DateTime? createdAt,
    @Default([]) List<TransactionItem> items,
  }) = _Transaction;
}

@freezed
abstract class CheckoutLine with _$CheckoutLine {
  const factory CheckoutLine({
    required String productId,
    required double qty,

    /// Server-priced online; the snapshot is only sent for offline sync.
    required int unitPrice,
    String? destination,
  }) = _CheckoutLine;
}

@freezed
abstract class CheckoutRequest with _$CheckoutRequest {
  const factory CheckoutRequest({
    required String userId,
    required PaymentMethod method,
    String? customerId,
    required List<CheckoutLine> lines,
  }) = _CheckoutRequest;
}

@freezed
abstract class CheckoutResult with _$CheckoutResult {
  const factory CheckoutResult({
    required String transactionId,
    required String invoice,
    required int total,
    required PaymentMethod method,
    @Default(false) bool stockConflict,
    int? debtRemaining,
  }) = _CheckoutResult;
}

/// A sale recorded on the device while offline, sent later through /transactions/sync.
@freezed
abstract class OfflineSale with _$OfflineSale {
  const factory OfflineSale({
    required String clientRef,
    required DateTime createdAt,
    required PaymentMethod method,
    String? customerId,
    required List<CheckoutLine> lines,
  }) = _OfflineSale;
}

enum SyncStatus { created, duplicate, failed }

@freezed
abstract class SyncResult with _$SyncResult {
  const SyncResult._();

  const factory SyncResult({
    required String clientRef,
    required SyncStatus status,
    String? transactionId,
    String? invoice,
    @Default(false) bool stockConflict,
    @Default(false) bool retryable,
    String? error,
  }) = _SyncResult;

  bool get accepted => status != SyncStatus.failed;
}

class TransactionQuery {
  const TransactionQuery({
    this.dateStart,
    this.dateEnd,
    this.method,
    this.invoice,
    this.openConflict = false,
    this.limit = 20,
  });

  final DateTime? dateStart;
  final DateTime? dateEnd;
  final PaymentMethod? method;
  final String? invoice;
  final bool openConflict;
  final int limit;
}
