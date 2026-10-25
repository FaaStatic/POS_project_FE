import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BulkState {
  const BulkState({this.saving = false, this.result, this.failure});
  final bool saving;
  final BulkImportResult? result;
  final Failure? failure;
}

class BulkProductsCubit extends Cubit<BulkState> {
  BulkProductsCubit(this._bulk) : super(const BulkState());
  final BulkCreateProducts _bulk;

  Future<void> submit(List<NewProduct> rows) async {
    if (state.saving) return;
    emit(const BulkState(saving: true));
    final result = await _bulk(rows);
    emit(switch (result) {
      Ok(:final value) => BulkState(result: value),
      Err(:final failure) => BulkState(failure: failure),
    });
  }
}
