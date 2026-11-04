import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/paged_list_cubit.dart';

class CustomersCubit extends PagedListCubit<Customer, CustomerQuery> {
  CustomersCubit(GetCustomers get, this._create, this._update, this._deactivate, this._restore, this._purge)
      : super(get.call, const CustomerQuery());

  final CreateCustomer _create;
  final UpdateCustomer _update;
  final DeactivateCustomer _deactivate;
  final RestoreCustomer _restore;
  final PurgeCustomer _purge;

  void showInactive(bool inactive) => load(CustomerQuery(inactive: inactive, search: query.search));
  void search(String text) => load(CustomerQuery(inactive: query.inactive, search: text));

  Future<Result<Customer>> create(CustomerInput input) => act(() => _create(input));
  Future<Result<void>> update(Customer c, CustomerInput input) => act(() => _update(c.id, input));
  Future<Result<void>> deactivate(Customer c) => act(() => _deactivate(c.id));
  Future<Result<void>> restore(Customer c) => act(() => _restore(c.id));
  Future<Result<PurgeMode>> purge(Customer c) => act(() => _purge(c));
}

class CustomerDetailState {
  const CustomerDetailState({
    this.loading = true,
    this.customer,
    this.openDebt,
    this.payments = const [],
    this.transactions = const [],
    this.failure,
  });
  final bool loading;
  final Customer? customer;

  /// The customer's unpaid debt; the backend allows one at a time and never sends it with the customer.
  final Debt? openDebt;

  /// The customer's newest debt payments, from any register or the CMS.
  final List<DebtPaymentEntry> payments;
  final List<Transaction> transactions;
  final Failure? failure;
}

/// Customer with debts plus the latest transactions.
class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit(this._get, this._transactions, this._debts, this._addDebt, this._payments, this._receipt, this._download)
      : super(const CustomerDetailState());
  final GetCustomer _get;
  final GetCustomerTransactions _transactions;
  final GetDebts _debts;
  final AddManualDebt _addDebt;
  final GetDebtPayments _payments;
  final GetDebtPaymentReceiptPdf _receipt;
  final DownloadReport _download;

  /// Generates one payment's receipt PDF and returns its bytes and file name.
  Future<Result<(List<int>, String)>> receipt(String paymentId) async {
    final path = await _receipt(paymentId);
    if (path case Err(:final failure)) return Err(failure);
    final p = (path as Ok<String>).value;
    return switch (await _download(p)) {
      Ok(:final value) => Ok((value, reportFileName(p))),
      Err(:final failure) => Err(failure),
    };
  }

  /// More credit for this customer; reloads the page data on success.
  Future<Result<void>> addDebt(String customerId, int amount, DateTime? due, String? note) async {
    final result = await _addDebt(customerId: customerId, amount: amount, dueDate: due, note: note);
    if (result case Ok()) await load(customerId);
    return result;
  }

  Future<void> load(String id) async {
    emit(const CustomerDetailState());
    final (customer, trx, debts, payments) = await (
      _get(id),
      _transactions(id),
      _debts(DebtQuery(customerId: id, unpaidOnly: true, limit: 1)),
      _payments(limit: 20, customerId: id),
    ).wait;
    emit(switch (customer) {
      Ok(:final value) => CustomerDetailState(
          loading: false,
          customer: value,
          openDebt: switch (debts) {
            Ok(:final value) => value.items.firstOrNull,
            Err() => null,
          },
          payments: switch (payments) {
            Ok(:final value) => value,
            Err() => const [],
          },
          transactions: switch (trx) {
            Ok(:final value) => value.items,
            Err() => const [],
          },
        ),
      Err(:final failure) => CustomerDetailState(loading: false, failure: failure),
    });
  }
}
