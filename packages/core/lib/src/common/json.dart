/// Lenient readers for backend JSON: numbers may arrive as int, double, or string.
int readInt(Object? v) => switch (v) {
      int() => v,
      num() => v.round(),
      String() => num.tryParse(v)?.round() ?? 0,
      _ => 0,
    };

double readDouble(Object? v) => switch (v) {
      num() => v.toDouble(),
      String() => double.tryParse(v) ?? 0,
      _ => 0,
    };

String readString(Object? v) => v == null ? '' : '$v';

String? readNullableString(Object? v) => v is String && v.isNotEmpty ? v : null;

DateTime? readDate(Object? v) => v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;

bool readBool(Object? v) => v == true || v == 'true' || v == 1;

List<Map<String, dynamic>> readList(Object? v) =>
    v is List ? v.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList() : const [];

Map<String, dynamic> readMap(Object? v) => v is Map ? v.cast<String, dynamic>() : const {};
