import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/debt.dart';
import '../repositories/debt_repository.dart';

class GetDebts {
  const GetDebts(this._repo);
  final DebtRepository _repo;

  Future<Result<Paged<Debt>>> call(DebtQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

class GetDebt {
  const GetDebt(this._repo);
  final DebtRepository _repo;

  Future<Result<Debt>> call(String id) => _repo.get(id);
}

class PayDebt {
  const PayDebt(this._repo);
  final DebtRepository _repo;

  Future<Result<DebtPaymentReceipt>> call({
    required Debt debt,
    required String userId,
    required int amount,
    required String idempotencyKey,
  }) {
    if (amount <= 0) return Future.value(const Err(ValidationFailure('positive_number')));
    if (amount > debt.remaining) return Future.value(const Err(ValidationFailure('exceeds_remaining')));
    return _repo.pay(debtId: debt.id, userId: userId, amount: amount, idempotencyKey: idempotencyKey);
  }
}

class AddManualDebt {
  const AddManualDebt(this._repo);
  final DebtRepository _repo;

  Future<Result<void>> call({required String customerId, required int amount, DateTime? dueDate}) {
    if (amount <= 0) return Future.value(const Err(ValidationFailure('positive_number')));
    return _repo.add(customerId: customerId, amount: amount, dueDate: dueDate);
  }
}
