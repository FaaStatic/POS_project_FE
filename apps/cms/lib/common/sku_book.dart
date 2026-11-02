import 'package:core/core.dart';

/// Works out the next free SKU for a product. It reads the SKUs already used from the backend,
/// once per category code and only for categories that share that code, since the backend cannot
/// search by SKU and a repeated SKU would overwrite another product on a bulk import.
class SkuBook {
  SkuBook(this._getTakenSkus);
  final GetTakenSkus _getTakenSkus;

  List<Category> _categories = const [];
  final _byCode = <String, Future<Set<String>?>>{};

  /// The store's categories. Setting them drops what was read, so an added or renamed one is seen.
  set categories(List<Category> value) {
    _categories = value;
    _byCode.clear();
  }

  /// Null while the name or category is missing, or when the existing SKUs cannot be read: a
  /// number picked without knowing what is taken could collide, so no SKU is offered instead.
  /// [reserved] are SKUs held elsewhere that are not in the backend yet, like other bulk rows.
  Future<String?> next({
    required String category,
    required ProductType type,
    required String name,
    Iterable<String> reserved = const [],
  }) async {
    final prefix = SkuGenerator.prefix(category: category, type: type, name: name);
    if (prefix == null) return null;
    final taken = await _takenUnder(SkuGenerator.categoryCode(category)!);
    if (taken == null) return null;
    return SkuGenerator.format(prefix, SkuGenerator.nextNumber(prefix, {...taken, ...reserved}));
  }

  Future<Set<String>?> _takenUnder(String code) {
    final read = _byCode.putIfAbsent(code, () async {
      final ids = [for (final c in _categories) if (SkuGenerator.categoryCode(c.name) == code) c.id];
      final result = await _getTakenSkus(ids);
      return result is Ok<Set<String>> ? result.value : null;
    });
    // A failed read is not remembered, so the next call tries again.
    read.then((taken) {
      if (taken == null) _byCode.remove(code);
    });
    return read;
  }
}
