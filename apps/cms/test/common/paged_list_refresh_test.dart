import 'dart:async';

import 'package:cms/common/paged_list_cubit.dart';
import 'package:cms/common/products_stale.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<int> rows;
  late int fetches;

  /// The next fetch waits on this instead of answering at once.
  Completer<Result<Paged<int>>>? gate;
  late PagedListCubit<int, String> cubit;

  setUp(() {
    rows = [1, 2, 3];
    fetches = 0;
    gate = null;
    cubit = PagedListCubit<int, String>((q, {after}) async {
      fetches++;
      final held = gate;
      gate = null;
      if (held != null) return held.future;
      return Ok(Paged(items: List.of(rows), cursor: const PageCursor(id: 'c', time: 't'), hasNext: after == null));
    }, '');
  });

  tearDown(() => cubit.close());

  test('refresh emits nothing when the first page is unchanged', () async {
    await cubit.load();
    final emitted = <PagedState<int>>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.refresh();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(fetches, 2);
    expect(emitted, isEmpty);
  });

  test('refresh emits once, without a loading state, when rows changed', () async {
    await cubit.load();
    rows = [1, 2, 3, 4];
    final emitted = <PagedState<int>>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.refresh();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, hasLength(1));
    expect(emitted.single.loading, isFalse);
    expect(emitted.single.items, [1, 2, 3, 4]);
  });

  test('a refresh asked during a refresh runs once more', () async {
    await cubit.load();
    final first = cubit.refresh();
    final second = cubit.refresh();
    await Future.wait([first, second]);
    expect(fetches, 3);
  });

  test('a refresh that was overtaken by a new search does not overwrite its rows', () async {
    await cubit.load();
    final held = gate = Completer();
    final refreshing = cubit.refresh();
    rows = [7];
    await cubit.load('b');
    held.complete(const Ok(Paged(items: [1, 2, 3])));
    await refreshing;
    expect(cubit.state.items, [7]);
  });

  test('a next page that was cut from the old cursor is dropped after a refresh', () async {
    await cubit.load();
    rows = [1, 2, 3];
    final held = gate = Completer();
    final more = cubit.loadMore();
    rows = [1, 2, 3, 9];
    await cubit.refresh();
    held.complete(const Ok(Paged(items: [4])));
    await more;
    expect(cubit.state.items, [1, 2, 3, 9]);
  });

  test('ProductsStale hands out each mark once', () {
    final stale = ProductsStale();
    expect(stale.take(), isFalse);
    stale.mark();
    expect(stale.take(), isTrue);
    expect(stale.take(), isFalse);
  });
}
