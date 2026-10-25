import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_cubits.freezed.dart';

@freezed
abstract class ProductsState with _$ProductsState {
  const factory ProductsState({
    @Default(true) bool loading,
    @Default([]) List<Product> products,
    @Default([]) List<Category> categories,
    @Default('') String query,
    String? categoryId,
  }) = _ProductsState;
}

/// Product list from the device cache (works offline). Shared by checkout and products.
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._cache) : super(const ProductsState());
  final CatalogCache _cache;
  StreamSubscription<List<Product>>? _products;
  StreamSubscription<List<Category>>? _categories;

  void start() {
    _categories = _cache.watchCategories().listen((c) => emit(state.copyWith(categories: c)));
    _watch();
  }

  void search(String query) {
    emit(state.copyWith(query: query));
    _watch();
  }

  void filter(String? categoryId) {
    emit(state.copyWith(categoryId: categoryId));
    _watch();
  }

  void _watch() {
    _products?.cancel();
    _products = _cache
        .watchProducts(search: state.query, categoryId: state.categoryId)
        .listen((p) => emit(state.copyWith(loading: false, products: p)));
  }

  @override
  Future<void> close() async {
    await _products?.cancel();
    await _categories?.cancel();
    return super.close();
  }
}

@freezed
abstract class CustomersState with _$CustomersState {
  const factory CustomersState({@Default(true) bool loading, @Default([]) List<Customer> customers, @Default('') String query}) =
      _CustomersState;
}

/// Searches the cached customer list, so it works offline.
class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._cache) : super(const CustomersState());
  final CatalogCache _cache;
  StreamSubscription<List<Customer>>? _sub;

  void search(String query) {
    _sub?.cancel();
    emit(state.copyWith(query: query));
    _sub = _cache.watchCustomers(search: query).listen((c) => emit(state.copyWith(loading: false, customers: c)));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

