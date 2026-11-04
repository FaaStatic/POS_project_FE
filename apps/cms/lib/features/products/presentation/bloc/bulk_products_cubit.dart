import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/products_stale.dart';

class BulkState {
  const BulkState({this.saving = false, this.result, this.failure, this.fileName});
  final bool saving;

  /// Set while a picked file is uploading.
  final String? fileName;
  final BulkImportResult? result;
  final Failure? failure;
}

class BulkProductsCubit extends Cubit<BulkState> {
  BulkProductsCubit(this._bulk, this._import, this._template, this._stale) : super(const BulkState());
  final BulkCreateProducts _bulk;
  final ImportProductsFile _import;
  final DownloadImportTemplate _template;
  final ProductsStale _stale;

  Future<Result<List<int>>> template() => _template();

  Future<void> importFile(List<int> bytes, String name) async {
    if (state.saving) return;
    emit(BulkState(saving: true, fileName: name));
    final result = await _import(bytes, name);
    if (result case Ok()) _stale.mark();
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
