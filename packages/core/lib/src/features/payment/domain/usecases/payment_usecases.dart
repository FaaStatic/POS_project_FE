import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/payment_method.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class ChargeQris {
  const ChargeQris(this._repo);
  final PaymentRepository _repo;

  Future<Result<Charge>> call({required String userId, String? customerId, required List<ChargeItem> items}) {
    if (items.isEmpty) return Future.value(const Err(ValidationFailure('empty_cart')));
    return _repo.chargeQris(userId: userId, customerId: customerId, items: items);
  }
}

class ChargeVa {
  const ChargeVa(this._repo);
  final PaymentRepository _repo;

  Future<Result<Charge>> call({
    required String userId,
    String? customerId,
    required VaBank bank,
    required List<ChargeItem> items,
  }) {
    if (items.isEmpty) return Future.value(const Err(ValidationFailure('empty_cart')));
    return _repo.chargeVa(userId: userId, customerId: customerId, bank: bank, items: items);
  }
}

class CheckPaymentStatus {
  const CheckPaymentStatus(this._repo);
  final PaymentRepository _repo;

  Future<Result<ChargeStatus>> call(String orderId) => _repo.status(orderId);
}

class GetPayments {
  const GetPayments(this._repo);
  final PaymentRepository _repo;

  Future<Result<Paged<PaymentRecord>>> call(PaymentQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}
