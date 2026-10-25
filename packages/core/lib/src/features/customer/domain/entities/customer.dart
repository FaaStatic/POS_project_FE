import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../debt/domain/entities/debt.dart';

part 'customer.freezed.dart';

@freezed
abstract class Customer with _$Customer {
  const Customer._();

  const factory Customer({
    required String id,
    required String name,
    @Default('') String phone,
    @Default('') String address,
    @Default(true) bool active,
    @Default([]) List<Debt> debts,
  }) = _Customer;

  int get outstandingDebt => debts.where((d) => !d.paid).fold(0, (sum, d) => sum + d.remaining);
  bool get hasActiveDebt => debts.any((d) => !d.paid && d.remaining > 0);
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
