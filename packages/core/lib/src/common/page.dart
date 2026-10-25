/// Keyset page from the backend (`after_id`/`after_time` or `next_id`/`next_time`).
class Page<T> {
  const Page({required this.items, this.cursor, this.hasNext = false});

  final List<T> items;
  final PageCursor? cursor;
  final bool hasNext;
}

class PageCursor {
  const PageCursor({required this.id, required this.time});
  final String id;
  final String time;

  static PageCursor? from(Object? id, Object? time) =>
      id is String && id.isNotEmpty && time is String && time.isNotEmpty ? PageCursor(id: id, time: time) : null;
}
