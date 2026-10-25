import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/payment_method.dart';
import '../entities/payment.dart';

abstract interface class PaymentRepository {
  Future<Result<Charge>> chargeQris({required String userId, String? customerId, required List<ChargeItem> items});
  Future<Result<Charge>> chargeVa({
    required String userId,
    String? customerId,
    required VaBank bank,
    required List<ChargeItem> items,
  });

  /// Also asks Midtrans for the latest state.
  Future<Result<ChargeStatus>> status(String orderId);
  Future<Result<Page<PaymentRecord>>> list(PaymentQuery query, {PageCursor? after});
}
