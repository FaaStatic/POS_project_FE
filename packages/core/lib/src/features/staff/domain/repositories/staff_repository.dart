import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../customer/domain/entities/customer.dart';
import '../entities/staff.dart';

abstract interface class StaffRepository {
  Future<Result<Paged<Staff>>> list(StaffQuery query, {PageCursor? after});
  Future<Result<void>> register(String username, String password);

  /// Sends only `password`; the backend revokes every session of that staff.
  Future<Result<void>> resetPassword(String id, String password);

  /// Revokes sessions and FCM tokens.
  Future<Result<void>> deactivate(String id);
  Future<Result<void>> restore(String id);

  /// Deleted when the staff has no transactions, anonymised otherwise.
  Future<Result<PurgeMode>> purge(String id, {required String confirmUsername});
}
