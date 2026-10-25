import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/debt.dart';

abstract interface class DebtRepository {
  Future<Result<Paged<Debt>>> list(DebtQuery query, {PageCursor? after});
  Future<Result<Debt>> get(String id);

  /// Cash payment. [idempotencyKey] makes a retried tap safe.
  Future<Result<DebtPaymentReceipt>> pay({
    required String debtId,
    required String userId,
    required int amount,
    required String idempotencyKey,
  });

  /// Manual debt (superadmin, CMS). [dueDate] is optional.
  Future<Result<void>> add({required String customerId, required int amount, DateTime? dueDate});
}
