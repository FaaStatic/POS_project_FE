import 'package:core/core.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/paged_list_cubit.dart';

class DebtsCubit extends PagedListCubit<Debt, DebtQuery> {
  DebtsCubit(GetDebts get, this._pay, this._add, this._session, this._customers)
      : super(get.call, const DebtQuery(unpaidOnly: true, oldestFirst: true));

  final PayDebt _pay;
  final AddManualDebt _add;
  final GetCurrentSession _session;
  final GetCustomers _customers;

  void unpaidOnly(bool v) => load(DebtQuery(unpaidOnly: v, oldestFirst: query.oldestFirst, search: query.search));
  void search(String text) => load(DebtQuery(unpaidOnly: query.unpaidOnly, oldestFirst: query.oldestFirst, search: text));

  /// [key] is created once per payment form so a resubmit is not paid twice.
  Future<Result<DebtPaymentReceipt>> pay(Debt d, int amount, String key) {
    final user = _session();
    if (user == null) return Future.value(const Err(UnauthorizedFailure()));
    return act(() => _pay(debt: d, userId: user.userId, amount: amount, idempotencyKey: key));
  }

  Future<Result<void>> addManual(String customerId, int amount, DateTime? due) =>
      act(() => _add(customerId: customerId, amount: amount, dueDate: due));

  Future<List<Customer>> findCustomers(String text) async => switch (await _customers(CustomerQuery(search: text, limit: 20))) {
        Ok(:final value) => value.items,
        Err() => const [],
      };

  static String newKey() => const Uuid().v4();
}
