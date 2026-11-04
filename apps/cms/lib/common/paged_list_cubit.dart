import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';

class PagedState<T> {
  const PagedState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.failure,
    this.cursor,
    this.hasNext = false,
  });

  final List<T> items;
  final bool loading;
  final bool loadingMore;
  final Failure? failure;
  final PageCursor? cursor;
  final bool hasNext;

  PagedState<T> copyWith({
    List<T>? items,
    bool? loading,
    bool? loadingMore,
    Failure? failure,
    bool clearFailure = false,
    PageCursor? cursor,
    bool? hasNext,
  }) =>
      PagedState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        failure: clearFailure ? null : failure ?? this.failure,
        cursor: cursor ?? this.cursor,
        hasNext: hasNext ?? this.hasNext,
      );
}

typedef PageFetcher<T, Q> = Future<Result<Paged<T>>> Function(Q query, {PageCursor? after});

/// Keyset-paged list with a query. Feature cubits extend it with their actions.
class PagedListCubit<T, Q> extends Cubit<PagedState<T>> {
  PagedListCubit(this._fetch, this.query) : super(PagedState<T>());

  final PageFetcher<T, Q> _fetch;
  Q query;

  /// Bumped whenever the shown rows are replaced; a fetch that started before that is stale
  /// (older query, or a next page cut from the old cursor) and is dropped.
  int _generation = 0;

  Future<void> load([Q? next]) async {
    if (next != null) query = next;
    final generation = ++_generation;
    emit(PagedState<T>(items: state.items));
    final result = await _fetch(query);
    if (isClosed || generation != _generation) return;
    emit(switch (result) {
      Ok(:final value) => PagedState(items: value.items, loading: false, cursor: value.cursor, hasNext: value.hasNext),
      Err(:final failure) => PagedState(loading: false, failure: failure),
    });
  }

  Future<void> loadMore() async {
    if (!state.hasNext || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    final generation = _generation;
    final result = await _fetch(query, after: state.cursor);
    if (isClosed || generation != _generation) return;
    emit(switch (result) {
      Ok(:final value) => state.copyWith(
          items: [...state.items, ...value.items],
          loadingMore: false,
          cursor: value.cursor,
          hasNext: value.hasNext,
        ),
      Err(:final failure) => state.copyWith(loadingMore: false, failure: failure),
    });
  }

  bool _refreshing = false;
  bool _refreshAgain = false;

  /// Refetches the first page without a spinner and emits only when the rows differ.
  /// Pages loaded past the first are dropped, as with [load]. A failed refetch keeps what is shown.
  /// A call during a refetch queues one more, so a change made meanwhile is not missed.
  Future<void> refresh() async {
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    try {
      do {
        _refreshAgain = false;
        final generation = _generation;
        final result = await _fetch(query);
        if (isClosed || generation != _generation) return;
        if (result case Ok(:final value) when !listEquals(state.items, value.items) || state.hasNext != value.hasNext) {
          _generation++;
          emit(PagedState(items: value.items, loading: false, cursor: value.cursor, hasNext: value.hasNext));
        }
      } while (_refreshAgain);
    } finally {
      _refreshing = false;
    }
  }

  /// Runs an action, refreshes on success, and passes the result back for a toast.
  Future<Result<R>> act<R>(Future<Result<R>> Function() action) async {
    final result = await action();
    if (result case Ok()) await refresh();
    return result;
  }
}
