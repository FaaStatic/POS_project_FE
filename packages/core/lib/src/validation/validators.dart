/// Mirrors backend validation so errors show before a round trip.
/// Each returns null when valid, or a stable error key the app translates.
abstract final class Validators {
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
