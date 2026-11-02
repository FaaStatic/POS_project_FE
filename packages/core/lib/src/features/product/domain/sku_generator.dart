import 'dart:math' as math;

import 'entities/product.dart';

/// Builds SKUs like `MIE-P-IG-001`: category code, `P`hysical or `D`igital, name acronym, and a
/// running number. It ports the sheet formula the store already uses, with the name acronym in
/// the place of its store-code cell.
abstract final class SkuGenerator {
  static const _maxAcronym = 6;
  static final _notAlnum = RegExp(r'[^A-Za-z0-9]');

  /// First three letters or digits of [category] with spaces and symbols dropped, upper case.
  static String? categoryCode(String category) {
    final s = category.replaceAll(_notAlnum, '');
    return s.isEmpty ? null : s.substring(0, math.min(3, s.length)).toUpperCase();
  }

  /// Initials of the words ("Indomie Goreng" is IG), at most six. Words that do not start with a
  /// letter (sizes like 600ml) are not initials. A lone word has none worth using, so its first
  /// three letters stand in ("Aqua 600ml" is AQU).
  static String? nameAcronym(String name) {
    final words = [
      for (final w in name.trim().split(RegExp(r'\s+'))) w.replaceFirst(RegExp(r'^[^A-Za-z0-9]+'), ''),
    ].where((w) => RegExp(r'^[A-Za-z]').hasMatch(w)).toList();
    if (words.length >= 2) return words.take(_maxAcronym).map((w) => w[0]).join().toUpperCase();
    final s = (words.isEmpty ? name : words.single).replaceAll(_notAlnum, '');
    return s.isEmpty ? null : s.substring(0, math.min(3, s.length)).toUpperCase();
  }

  /// Everything before the running number; null while the category or name has nothing to build on.
  static String? prefix({required String category, required ProductType type, required String name}) {
    final code = categoryCode(category);
    final acronym = nameAcronym(name);
    if (code == null || acronym == null) return null;
    return '$code-${type == ProductType.digital ? 'D' : 'P'}-$acronym';
  }

  /// One past the highest number already used under [prefix]. Gaps are not refilled, so a
  /// deleted product's number is not handed out again.
  static int nextNumber(String prefix, Iterable<String> taken) {
    final lead = '$prefix-';
    var highest = 0;
    for (final sku in taken) {
      if (!sku.startsWith(lead)) continue;
      final rest = sku.substring(lead.length);
      if (RegExp(r'^\d+$').hasMatch(rest)) highest = math.max(highest, int.parse(rest));
    }
    return highest + 1;
  }

  static String format(String prefix, int number) => '$prefix-${number.toString().padLeft(3, '0')}';
}
