import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<Result<CheckoutResult>> create(CheckoutRequest request);
  Future<Result<Transaction>> get(String id);
  Future<Result<Paged<Transaction>>> list(TransactionQuery query, {PageCursor? after});
  Future<Result<Paged<Transaction>>> listByCustomer(String customerId, {PageCursor? after});

  /// Reason is required (3–500 characters).
  Future<Result<void>> cancel(String id, String reason);

  /// Up to 100 sales per call; results come back per item.
  Future<Result<List<SyncResult>>> sync(List<OfflineSale> sales);

  Future<Result<void>> markConflictReviewed(String id);

  /// Generates the PDF and returns its download path under /api/reports.
  Future<Result<String>> receiptPdf(String id);
  Future<Result<String>> monthlyReportPdf(int month, int year);
}
