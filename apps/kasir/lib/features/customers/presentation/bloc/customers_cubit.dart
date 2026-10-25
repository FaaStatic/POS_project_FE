import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customers_cubit.freezed.dart';

@freezed
abstract class CustomerFormState with _$CustomerFormState {
  const factory CustomerFormState({@Default(false) bool saving, Customer? saved, Failure? failure}) =
      _CustomerFormState;
}

/// Adding a customer needs the server id, so it is online only.
class AddCustomerCubit extends Cubit<CustomerFormState> {
  AddCustomerCubit(this._create, this._cache, this._network) : super(const CustomerFormState());
  final CreateCustomer _create;
  final CatalogCache _cache;
  final NetworkStatus _network;

  Future<void> save(CustomerInput input) async {
    if (state.saving) return;
    if (!await _network.isOnline()) {
      emit(state.copyWith(failure: const NetworkFailure()));
      return;
    }
    emit(state.copyWith(saving: true, failure: null));
    final result = await _create(input);
    if (result case Ok(:final value)) await _cache.upsertCustomer(value);
    emit(switch (result) {
      Ok(:final value) => state.copyWith(saving: false, saved: value),
      Err(:final failure) => state.copyWith(saving: false, failure: failure),
    });
  }
}

@freezed
abstract class CustomerDetailState with _$CustomerDetailState {
  const factory CustomerDetailState({@Default(true) bool loading, Customer? customer, Failure? failure}) =
      _CustomerDetailState;
}

class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit(this._get, this._cache) : super(const CustomerDetailState());
  final GetCustomer _get;
  final CatalogCache _cache;

  /// Shows the cached copy first, then the server copy with debts.
  Future<void> load(String id) async {
    final cached = await _cache.customer(id);
    emit(CustomerDetailState(loading: true, customer: cached));
    final result = await _get(id);
    emit(switch (result) {
      Ok(:final value) => CustomerDetailState(loading: false, customer: value),
      Err(:final failure) => CustomerDetailState(loading: false, customer: cached, failure: failure),
    });
  }
}
