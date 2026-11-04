import 'dart:math' as math;

/// Mirrors backend validation so errors show before a round trip.
/// Each returns null when valid, or a stable error key the app translates.
abstract final class Validators {
  /// Largest stock or quantity the backend column holds (`numeric(12,3)`).
  static const _maxQuantity = 999999999.999;

  static final _barcode = RegExp(r'^[A-Za-z0-9\-._]{1,64}$');

  static String? required(String? v) => v == null || v.trim().isEmpty ? 'required' : null;

  static String? username(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'required';
    return s.length < 3 || s.length > 100 ? 'username_length' : null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'required';
    return v.length < 6 ? 'password_length' : null;
  }

  /// Optional field: empty is valid.
  static String? barcode(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    return _barcode.hasMatch(s) ? null : 'barcode_format';
  }

  static String? sku(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'required';
    return s.length > 50 ? 'sku_length' : null;
  }

  static String? positiveInt(String? v) {
    final n = int.tryParse(v?.trim() ?? '');
    return n == null || n <= 0 ? 'positive_number' : null;
  }

  static String? nonNegativeNumber(String? v) {
    final n = num.tryParse((v ?? '').trim().replaceAll(',', '.'));
    return n == null || n < 0 ? 'non_negative_number' : null;
  }

  /// Stock or quantity as the backend checks it: a finite number within the backend range with at
  /// most 3 decimals, whole for pcs. [signed] allows a negative stock adjustment. A comma
  /// counts as the decimal point.
  static String? quantity(String? v, {bool whole = false, bool signed = false}) {
    final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
    if (n == null || !n.isFinite || (!signed && n < 0)) return 'non_negative_number';
    if (n.abs() > _maxQuantity) return 'qty_too_large';
    if (whole && n != n.truncateToDouble()) return 'qty_whole';
    // Same tolerance as the backend: float64 near 1e12 is only exact to about 1e-4.
    final scaled = n * 1000;
    if ((scaled - scaled.roundToDouble()).abs() > math.max(1e-6, scaled.abs() * 1e-15)) return 'qty_decimals';
    return null;
  }

  /// Transaction cancel reason: 3–500 characters.
  static String? cancelReason(String? v) {
    final s = v?.trim() ?? '';
    return s.length < 3 || s.length > 500 ? 'reason_length' : null;
  }

  static String? categoryName(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'required';
    return s.length > 100 ? 'category_length' : null;
  }

  /// Category uniqueness key used by the backend.
  static String categoryKey(String name) => name.trim().toLowerCase();
}
