/// Set when a bulk import changed the product list from another screen, so the list
/// refetches once when it is shown again instead of on a timer.
class ProductsStale {
  bool _stale = false;

  void mark() => _stale = true;

  /// True once per [mark]; the caller refetches.
  bool take() {
    final stale = _stale;
    _stale = false;
    return stale;
  }
}
