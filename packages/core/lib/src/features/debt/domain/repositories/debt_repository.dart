import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/debt.dart';

abstract interface class DebtRepository {
  Future<Result<Paged<Debt>>> list(DebtQuery query, {PageCursor? after});
  /// The newest payments, any register or the CMS; [customerId] narrows it to one customer.
  Future<Result<List<DebtPaymentEntry>>> listPayments({int limit = 50, String? customerId});

  /// PDF paths (`url_pdf`) of one payment's receipt and of a month's recap for every customer.
  Future<Result<String>> paymentReceiptPdf(String paymentId);
  Future<Result<String>> paymentsRecapPdf(int month, int year);

  /// Every unpaid debt, all pages; the kasir keeps these for its offline debt tab.
  Future<Result<List<Debt>>> listUnpaid();

  /// Cash payment. [idempotencyKey] makes a retried tap safe.
  Future<Result<DebtPaymentReceipt>> pay({
    required String debtId,
    required String userId,
    required int amount,
    required String idempotencyKey,
  });

  /// Manual debt (superadmin, CMS): adds [amount] to the customer's open debt, or opens one.
  /// [dueDate] replaces the due date when given; [note] says what the debt is for.
  Future<Result<void>> add({required String customerId, required int amount, DateTime? dueDate, String? note});
}
