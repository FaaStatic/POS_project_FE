import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../validation/validators.dart';
import '../../../customer/domain/entities/customer.dart';
import '../entities/staff.dart';
import '../repositories/staff_repository.dart';

class GetStaff {
  const GetStaff(this._repo);
  final StaffRepository _repo;

  Future<Result<Paged<Staff>>> call(StaffQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

class RegisterStaff {
  const RegisterStaff(this._repo);
  final StaffRepository _repo;

  Future<Result<void>> call(String username, String password) {
    final error = Validators.username(username) ?? Validators.password(password);
    if (error != null) return Future.value(Err(ValidationFailure(error)));
    return _repo.register(username.trim(), password);
  }
}

class ResetStaffPassword {
  const ResetStaffPassword(this._repo);
  final StaffRepository _repo;

  Future<Result<void>> call(String id, String password) {
    final error = Validators.password(password);
    if (error != null) return Future.value(Err(ValidationFailure(error)));
    return _repo.resetPassword(id, password);
  }
}

class DeactivateStaff {
  const DeactivateStaff(this._repo);
  final StaffRepository _repo;

  Future<Result<void>> call(String id) => _repo.deactivate(id);
}

class RestoreStaff {
  const RestoreStaff(this._repo);
  final StaffRepository _repo;

  Future<Result<void>> call(String id) => _repo.restore(id);
}

/// Permanent delete requires typing the staff's name exactly.
class PurgeStaff {
  const PurgeStaff(this._repo);
  final StaffRepository _repo;

  Future<Result<PurgeMode>> call(Staff staff, String typedName) {
    if (typedName.trim() != staff.username) return Future.value(const Err(ValidationFailure('confirm_mismatch')));
    return _repo.purge(staff.id, confirmUsername: staff.username);
  }
}
