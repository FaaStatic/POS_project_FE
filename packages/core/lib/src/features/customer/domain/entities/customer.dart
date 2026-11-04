import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    @Default('') String phone,
    @Default('') String address,
    @Default(true) bool active,
  }) = _Customer;
}

@freezed
abstract class CustomerInput with _$CustomerInput {
  const factory CustomerInput({required String name, @Default('') String phone, @Default('') String address}) =
      _CustomerInput;
}

/// Result of a permanent delete: removed, or kept anonymised for reports.
enum PurgeMode { deleted, anonymized }

class CustomerQuery {
  const CustomerQuery({this.search, this.inactive = false, this.limit = 50});
  final String? search;
  final bool inactive;
  final int limit;
}
