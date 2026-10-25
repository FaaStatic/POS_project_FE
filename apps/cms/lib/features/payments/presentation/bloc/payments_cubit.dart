import 'package:core/core.dart';

import '../../../../common/paged_list_cubit.dart';

/// Monitoring only: charges are created from the kasir.
class PaymentsCubit extends PagedListCubit<PaymentRecord, PaymentQuery> {
  PaymentsCubit(GetPayments get, this._status, {PaymentQuery initial = const PaymentQuery()}) : super(get.call, initial);
  final CheckPaymentStatus _status;

  void filterState(PaymentState? s) => load(PaymentQuery(state: s, method: query.method, dateStart: query.dateStart, dateEnd: query.dateEnd));
  void method(ChargeMethod? m) => load(PaymentQuery(state: query.state, method: m, dateStart: query.dateStart, dateEnd: query.dateEnd));
  void dates(DateTime? start, DateTime? end) => load(PaymentQuery(state: query.state, method: query.method, dateStart: start, dateEnd: end));

  /// Asks Midtrans through the backend, then refreshes the list.
  Future<Result<ChargeStatus>> check(PaymentRecord p) => act(() => _status(p.orderId));
}
