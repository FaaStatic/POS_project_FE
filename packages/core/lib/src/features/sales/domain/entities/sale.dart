import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/payment_method.dart';
import '../../../transaction/domain/entities/change_line.dart';

part 'sale.freezed.dart';

enum SaleStatus { pending, synced, failed, cancelled }

/// A debt payment is recorded in the same log as sales: same queue, history, and receipt.
enum SaleKind { sale, debtPayment }

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

    /// Cash received and the change given back, when the cashier recorded them.
    int? amountPaid,
    @Default([]) List<ChangeLine> change,
    @Default(SaleKind.sale) SaleKind kind,

    /// Debt payments only: the debt paid toward, its original total, and what is owed before and after.
    String? debtId,
    int? debtTotal,
    int? debtBefore,
    int? debtAfter,
  }) = _Sale;

  bool get isSynced => status == SaleStatus.synced;
  bool get isOffline => receiptNumber.startsWith('OFF-') || receiptNumber.startsWith('HTG-');
  bool get isDebtPayment => kind == SaleKind.debtPayment;

  /// A debt payment that cleared the debt.
  /// Everything paid toward the debt so far, this payment included.
  int get debtPaidSoFar => (debtTotal ?? 0) - (debtAfter ?? 0);
  bool get debtSettled => isDebtPayment && debtAfter == 0;
}
