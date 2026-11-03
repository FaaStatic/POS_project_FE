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

    /// More rows are waiting in the cache past the page window (only with a page size).
    @Default(false) bool hasMore,
  }) = _ProductsState;
}

/// Product list from the device cache (works offline). Shared by checkout and products.
///
/// With a `pageSize` the cache is read one window at a time: [loadMore] widens it, and a new
/// search or filter starts again from the first page. Without one, every product is read.
class ProductsCubit extends Cubit<ProductsState> {
  /// [debounce] is how long typing must pause before the cache is queried again; zero queries
  /// at once.
  ProductsCubit(this._cache, {this.debounce = Duration.zero}) : super(const ProductsState());
  final CatalogCache _cache;
  final Duration debounce;
  StreamSubscription<List<Product>>? _products;
  StreamSubscription<List<Category>>? _categories;
  Timer? _typing;
  int? _pageSize;
  int? _limit;

  /// A wider window was asked for and has not arrived yet; stops a fast scroll from skipping pages.
  bool _widening = false;

  void start({int? pageSize}) {
    _pageSize = _limit = pageSize;
    _categories = _cache.watchCategories().listen((c) => emit(state.copyWith(categories: c)));
    _watch();
  }

  void search(String query) {
    // The field shows what was typed at once; only the cache query waits for a pause.
    emit(state.copyWith(query: query));
    _typing?.cancel();
    if (debounce == Duration.zero) {
      _restart();
    } else {
      _typing = Timer(debounce, _restart);
    }
  }

  void filter(String? categoryId) {
    emit(state.copyWith(categoryId: categoryId));
    _restart();
  }

  void loadMore() {
    final size = _pageSize;
    final limit = _limit;
    if (size == null || limit == null || !state.hasMore || _widening) return;
    _widening = true;
    _limit = limit + size;
    _watch();
  }

  void _restart() {
    _limit = _pageSize;
    _watch();
  }

  void _watch() {
    _products?.cancel();
    final limit = _limit;
    _products = _cache.watchProducts(search: state.query, categoryId: state.categoryId, limit: limit).listen((p) {
      _widening = false;
      emit(state.copyWith(loading: false, products: p, hasMore: limit != null && p.length >= limit));
    });
  }

  @override
  Future<void> close() async {
    _typing?.cancel();
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

