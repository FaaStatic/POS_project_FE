import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/paged_list_cubit.dart';

class TransactionsCubit extends PagedListCubit<Transaction, TransactionQuery> {
  TransactionsCubit(GetTransactions get, {bool conflictsOnly = false})
      : super(get.call, TransactionQuery(openConflict: conflictsOnly));

  TransactionQuery _with({DateTime? start, DateTime? end, PaymentMethod? method, String? invoice, bool? conflicts, bool clearDates = false, bool clearMethod = false}) =>
      TransactionQuery(
        dateStart: clearDates ? null : start ?? query.dateStart,
        dateEnd: clearDates ? null : end ?? query.dateEnd,
        method: clearMethod ? null : method ?? query.method,
        invoice: invoice ?? query.invoice,
        openConflict: conflicts ?? query.openConflict,
      );

  void dates(DateTime? start, DateTime? end) => load(_with(start: start, end: end, clearDates: start == null));
  void method(PaymentMethod? m) => load(_with(method: m, clearMethod: m == null));
  void invoice(String text) => load(_with(invoice: text));
  void conflicts(bool only) => load(_with(conflicts: only));
}

class TransactionDetailState {
  const TransactionDetailState({this.loading = true, this.transaction, this.failure, this.working = false});
  final bool loading;
  final Transaction? transaction;
  final Failure? failure;
  final bool working;
}

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  TransactionDetailCubit(this._get, this._cancel, this._review, this._receipt, this._download) : super(const TransactionDetailState());
  final GetTransaction _get;
  final CancelTransaction _cancel;
  final MarkConflictReviewed _review;
  final GetReceiptPdf _receipt;
  final DownloadReport _download;

  Future<void> load(String id) async {
    final result = await _get(id);
    emit(switch (result) {
      Ok(:final value) => TransactionDetailState(loading: false, transaction: value),
      Err(:final failure) => TransactionDetailState(loading: false, failure: failure),
    });
  }

  Future<Result<T>> _work<T>(Future<Result<T>> Function() action) async {
    emit(TransactionDetailState(loading: false, transaction: state.transaction, working: true));
    final result = await action();
    emit(TransactionDetailState(loading: false, transaction: state.transaction));
    return result;
  }

  Future<Result<void>> cancel(String reason) => _work(() => _cancel(state.transaction!.id, reason));

  Future<Result<void>> markReviewed() async {
    final result = await _work(() => _review(state.transaction!.id));
    if (result case Ok()) await load(state.transaction!.id);
    return result;
  }

  /// Generates the receipt PDF and returns its bytes and file name.
  Future<Result<(List<int>, String)>> receipt() => _work(() async {
        final path = await _receipt(state.transaction!.id);
        if (path case Err(:final failure)) return Err(failure);
        final p = (path as Ok<String>).value;
        return switch (await _download(p)) {
          Ok(:final value) => Ok((value, reportFileName(p))),
          Err(:final failure) => Err(failure),
        };
      });
}
