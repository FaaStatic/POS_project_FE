import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/payment_method.dart';
import '../../../../validation/validators.dart';
import '../entities/change_line.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Shared by online checkout and the offline queue.
String? validateCheckout(PaymentMethod method, String? customerId, List<CheckoutLine> lines) {
  if (lines.isEmpty) return 'empty_cart';
  if (lines.any((l) => l.qty <= 0)) return 'invalid_qty';
  if (method == PaymentMethod.debt && (customerId == null || customerId.isEmpty)) return 'debt_needs_customer';
  if (lines.any((l) => l.destination != null && l.destination!.trim().isEmpty)) return 'destination_required';
  return null;
}

/// Cash received and the change handed back, mirroring the backend rule: lines add up
/// to `amountPaid - total`. Without an amount paid nothing is recorded, as before.
String? validateChange({
  required PaymentMethod method,
  required int total,
  required int? amountPaid,
  required List<ChangeLine> change,
}) {
  if (amountPaid == null) return change.isEmpty ? null : 'amount_paid_required';
  if (method != PaymentMethod.cash) return 'change_cash_only';
  if (amountPaid < total) return 'amount_paid_short';
  if (change.length > 20) return 'change_too_many';
  var given = 0;
  for (final line in change) {
    if (line.amount <= 0) return 'change_invalid';
    if (!line.isCash) {
      if (line.productId == null || line.qty <= 0) return 'change_invalid';
      final scaled = line.qty * 1000;
      final threeDecimals = (scaled - scaled.roundToDouble()).abs() < 1e-6;
      if (!threeDecimals || (line.wholeOnly && line.qty != line.qty.truncateToDouble())) return 'invalid_qty';
    }
    given += line.amount;
  }
  return given == amountPaid - total ? null : 'change_mismatch';
}

class GetTransaction {
  const GetTransaction(this._repo);
  final TransactionRepository _repo;

  Future<Result<Transaction>> call(String id) => _repo.get(id);
}

class GetTransactions {
  const GetTransactions(this._repo);
  final TransactionRepository _repo;

  Future<Result<Paged<Transaction>>> call(TransactionQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

class GetCustomerTransactions {
  const GetCustomerTransactions(this._repo);
  final TransactionRepository _repo;

  Future<Result<Paged<Transaction>>> call(String customerId, {PageCursor? after}) =>
      _repo.listByCustomer(customerId, after: after);
}

class CancelTransaction {
  const CancelTransaction(this._repo);
  final TransactionRepository _repo;

  Future<Result<void>> call(String id, String reason) {
    if (Validators.cancelReason(reason) != null) return Future.value(const Err(ValidationFailure('reason_length')));
    return _repo.cancel(id, reason.trim());
  }
}

class MarkConflictReviewed {
  const MarkConflictReviewed(this._repo);
  final TransactionRepository _repo;

  Future<Result<void>> call(String id) => _repo.markConflictReviewed(id);
}

class GetReceiptPdf {
  const GetReceiptPdf(this._repo);
  final TransactionRepository _repo;

  Future<Result<String>> call(String id) => _repo.receiptPdf(id);
}

class GetMonthlyReportPdf {
  const GetMonthlyReportPdf(this._repo);
  final TransactionRepository _repo;

  Future<Result<String>> call(int month, int year) => _repo.monthlyReportPdf(month, year);
}
