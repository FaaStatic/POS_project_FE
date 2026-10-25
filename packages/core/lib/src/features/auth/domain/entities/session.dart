import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/roles.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String username,
    required UserRole role,
  }) = _Session;
}
