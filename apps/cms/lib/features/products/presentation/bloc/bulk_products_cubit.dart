import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BulkState {
  const BulkState({this.saving = false, this.result, this.failure, this.fileName});
  final bool saving;

  /// Set while a picked file is uploading.
  final String? fileName;
  final BulkImportResult? result;
  final Failure? failure;
}

class BulkProductsCubit extends Cubit<BulkState> {
  BulkProductsCubit(this._bulk, this._import) : super(const BulkState());
  final BulkCreateProducts _bulk;
  final ImportProductsFile _import;

  Future<void> importFile(List<int> bytes, String name) async {
    if (state.saving) return;
    emit(BulkState(saving: true, fileName: name));
    final result = await _import(bytes, name);
    emit(switch (result) {
      Ok(:final value) => BulkState(result: value),
      Err(:final failure) => BulkState(failure: failure),
    });
  }

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
