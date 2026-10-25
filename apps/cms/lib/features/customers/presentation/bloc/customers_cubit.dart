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
  const CustomerDetailState({this.loading = true, this.customer, this.transactions = const [], this.failure});
  final bool loading;
  final Customer? customer;
  final List<Transaction> transactions;
  final Failure? failure;
}

/// Customer with debts plus the latest transactions.
class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit(this._get, this._transactions) : super(const CustomerDetailState());
  final GetCustomer _get;
  final GetCustomerTransactions _transactions;

  Future<void> load(String id) async {
    emit(const CustomerDetailState());
    final (customer, trx) = await (_get(id), _transactions(id)).wait;
    emit(switch (customer) {
      Ok(:final value) => CustomerDetailState(
          loading: false,
          customer: value,
          transactions: switch (trx) {
            Ok(:final value) => value.items,
            Err() => const [],
          },
        ),
      Err(:final failure) => CustomerDetailState(loading: false, failure: failure),
    });
  }
}
