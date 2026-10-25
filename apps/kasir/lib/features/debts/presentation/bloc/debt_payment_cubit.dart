import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'debt_payment_cubit.freezed.dart';

@freezed
abstract class DebtPaymentState with _$DebtPaymentState {
  const factory DebtPaymentState({
    @Default(true) bool loading,
    Debt? debt,
    @Default(false) bool paying,
    DebtPaymentReceipt? receipt,
    Failure? failure,
  }) = _DebtPaymentState;
}

class DebtPaymentCubit extends Cubit<DebtPaymentState> {
  DebtPaymentCubit(this._get, this._pay, this._session, {String? idempotencyKey})
      : _key = idempotencyKey ?? const Uuid().v4(),
        super(const DebtPaymentState());

  final GetDebt _get;
  final PayDebt _pay;
  final GetCurrentSession _session;

  /// One key per screen: a retried tap after a dropped response is not paid twice.
  final String _key;

  Future<void> load(String debtId) async {
    emit(const DebtPaymentState());
    final result = await _get(debtId);
    emit(switch (result) {
      Ok(:final value) => DebtPaymentState(loading: false, debt: value),
      Err(:final failure) => DebtPaymentState(loading: false, failure: failure),
    });
  }

  Future<void> pay(int amount) async {
    final debt = state.debt;
    final user = _session();
    if (debt == null || state.paying) return;
    if (user == null) {
      emit(state.copyWith(failure: const UnauthorizedFailure()));
      return;
    }
    emit(state.copyWith(paying: true, failure: null));
    final result = await _pay(debt: debt, userId: user.userId, amount: amount, idempotencyKey: _key);
    emit(switch (result) {
      Ok(:final value) => state.copyWith(
          paying: false,
          receipt: value,
          debt: debt.copyWith(remaining: value.remaining, paid: value.paid),
        ),
      Err(:final failure) => state.copyWith(paying: false, failure: failure),
    });
  }
}
