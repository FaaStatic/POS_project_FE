import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assign_barcode_cubit.freezed.dart';

@freezed
abstract class AssignBarcodeState with _$AssignBarcodeState {
  const factory AssignBarcodeState({@Default(false) bool saving, Product? product, Failure? failure}) =
      _AssignBarcodeState;
}

/// Picks a product for an unknown scanned barcode and saves it (online).
class AssignBarcodeCubit extends Cubit<AssignBarcodeState> {
  AssignBarcodeCubit(this._assign, this._cache) : super(const AssignBarcodeState());
  final AssignBarcode _assign;
  final CatalogCache _cache;

  Future<void> assign(Product product, String code) async {
    if (state.saving) return;
    emit(state.copyWith(saving: true, failure: null));
    final result = await _assign(product.id, code);
    if (result case Ok(:final value)) await _cache.upsertProduct(value);
    emit(switch (result) {
      Ok(:final value) => state.copyWith(saving: false, product: value),
      Err(:final failure) => state.copyWith(saving: false, failure: failure),
    });
  }
}
