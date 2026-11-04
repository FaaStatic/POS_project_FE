import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show listEquals;
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

    /// The next window is being read; the list shows its spinner only for this short gap.
    @Default(false) bool loadingMore,
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
    emit(state.copyWith(loadingMore: true));
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
      final hasMore = limit != null && p.length >= limit;
      // Drift re-emits after any write to the table; an unchanged page must not rebuild the list.
      if (!state.loading && !state.loadingMore && state.hasMore == hasMore && listEquals(state.products, p)) return;
      emit(state.copyWith(loading: false, products: p, hasMore: hasMore, loadingMore: false));
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
  CustomersCubit(this._cache, this._refresh) : super(const CustomersState());
  final CatalogCache _cache;
  final RefreshCustomers _refresh;
  StreamSubscription<List<Customer>>? _sub;
  DateTime? _lastRefresh;
  bool _refreshing = false;

  /// Customers shown again within this gap are not pulled a second time.
  static const refreshGap = Duration(seconds: 30);

  /// Pulls the server's customer list into the cache; the list below updates from the cache.
  /// Without [force] a recent pull is reused. Resolves to the failure, or null when it worked
  /// or was skipped, so a pull-to-refresh can say what went wrong.
  Future<Failure?> refresh({bool force = false}) async {
    final last = _lastRefresh;
    if (_refreshing || (!force && last != null && DateTime.now().difference(last) < refreshGap)) return null;
    _refreshing = true;
    try {
      final result = await _refresh();
      if (result case Err(:final failure)) return failure;
      _lastRefresh = DateTime.now();
      return null;
    } finally {
      _refreshing = false;
    }
  }

  void search(String query) {
    _sub?.cancel();
    emit(state.copyWith(query: query));
    _sub = _cache.watchCustomers(search: query).listen((c) {
      if (!state.loading && listEquals(state.customers, c)) return;
      emit(state.copyWith(loading: false, customers: c));
    });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

@freezed
abstract class DebtsState with _$DebtsState {
  const factory DebtsState({@Default(true) bool loading, @Default([]) List<Debt> debts, @Default('') String query}) = _DebtsState;
}

/// Customers with an open debt, from the device cache, for the "Bayar hutang" tab.
class DebtsCubit extends Cubit<DebtsState> {
  DebtsCubit(this._cache) : super(const DebtsState());
  final CatalogCache _cache;
  StreamSubscription<List<Debt>>? _sub;

  void search(String query) {
    _sub?.cancel();
    emit(state.copyWith(query: query));
    _sub = _cache.watchDebts(search: query).listen((d) {
      if (!state.loading && listEquals(state.debts, d)) return;
      emit(state.copyWith(loading: false, debts: d));
    });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
