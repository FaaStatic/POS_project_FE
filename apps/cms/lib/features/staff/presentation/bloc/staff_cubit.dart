import 'package:core/core.dart';

import '../../../../common/paged_list_cubit.dart';

class StaffCubit extends PagedListCubit<Staff, StaffQuery> {
  StaffCubit(GetStaff get, this._register, this._reset, this._deactivate, this._restore, this._purge)
      : super(get.call, const StaffQuery());

  final RegisterStaff _register;
  final ResetStaffPassword _reset;
  final DeactivateStaff _deactivate;
  final RestoreStaff _restore;
  final PurgeStaff _purge;

  void showInactive(bool inactive) => load(StaffQuery(inactive: inactive, search: query.search));
  void search(String text) => load(StaffQuery(inactive: query.inactive, search: text));

  Future<Result<void>> register(String username, String password) => act(() => _register(username, password));
  Future<Result<void>> resetPassword(Staff s, String password) => _reset(s.id, password);
  Future<Result<void>> deactivate(Staff s) => act(() => _deactivate(s.id));
  Future<Result<void>> restore(Staff s) => act(() => _restore(s.id));
  Future<Result<PurgeMode>> purge(Staff s, String typed) => act(() => _purge(s, typed));
}
