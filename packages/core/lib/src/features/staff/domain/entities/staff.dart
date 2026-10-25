import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/roles.dart';

part 'staff.freezed.dart';

@freezed
abstract class Staff with _$Staff {
  const factory Staff({
    required String id,
    required String username,
    required UserRole role,
    @Default(true) bool active,
    DateTime? createdAt,
  }) = _Staff;
}

class StaffQuery {
  const StaffQuery({this.search, this.inactive = false, this.limit = 50});
  final String? search;
  final bool inactive;
  final int limit;
}
