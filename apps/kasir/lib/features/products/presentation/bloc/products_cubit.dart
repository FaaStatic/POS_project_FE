import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_cubit.freezed.dart';

@freezed
abstract class ProductEditState with _$ProductEditState {
  const factory ProductEditState({
    @Default(true) bool loading,
    Product? product,
    @Default(false) bool saving,
    @Default(false) bool saved,
    Failure? failure,
  }) = _ProductEditState;
}

/// Edits go to the server only; staff fields are enforced again by the backend.
class ProductEditCubit extends Cubit<ProductEditState> {
  ProductEditCubit(this._get, this._update, this._adjust, this._cache) : super(const ProductEditState());
  final GetProduct _get;
  final UpdateProduct _update;
  final AdjustStock _adjust;
  final CatalogCache _cache;

  Future<void> load(String id) async {
    final cached = await _cache.product(id);
    emit(ProductEditState(loading: true, product: cached));
    final result = await _get(id);
    emit(switch (result) {
      Ok(:final value) => ProductEditState(loading: false, product: value),
      Err(:final failure) => ProductEditState(loading: false, product: cached, failure: failure),
    });
  }

  Future<void> save(ProductPatch patch, {double stockDelta = 0}) async {
    final product = state.product;
    if (product == null || state.saving) return;
    emit(state.copyWith(saving: true, failure: null, saved: false));
    if (stockDelta != 0) {
      if (await _adjust(product.id, stockDelta) case Err(:final failure)) {
        emit(state.copyWith(saving: false, failure: failure));
        return;
      }
    }
    final result = await _update(product.id, patch);
    if (result case Ok(:final value)) await _cache.upsertProduct(value);
    emit(switch (result) {
      Ok(:final value) => state.copyWith(saving: false, saved: true, product: value),
      Err(:final failure) => state.copyWith(saving: false, failure: failure),
    });
  }
}

