import '../../../common/guard.dart';
import '../../../common/json.dart';
import '../../../common/page.dart';
import '../../../common/result.dart';
import '../../../constants/api_paths.dart';
import '../../../constants/roles.dart';
import '../../../network/api_client.dart';
import '../../customer/data/repositories/customer_repository_impl.dart';
import '../../customer/domain/entities/customer.dart';
import '../domain/entities/staff.dart';
import '../domain/repositories/staff_repository.dart';

Staff staffFromJson(Map<String, dynamic> j) => Staff(
      id: readString(j['id']),
      username: readString(j['username']),
      role: UserRole.parse(readString(j['role'])),
      active: j['active'] == null || readBool(j['active']),
      createdAt: readDate(j['created_at']),
    );

class StaffRepositoryImpl implements StaffRepository {
  const StaffRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<Result<Paged<Staff>>> list(StaffQuery q, {PageCursor? after}) => guard(() async {
        final data = readMap(await _api.get(ApiPaths.users, query: {
          'status': q.inactive ? 'inactive' : 'active',
          'search': q.search,
          'limit': q.limit,
          'after_id': after?.id,
          'after_time': after?.time,
        }));
        return Paged(
          items: readList(data['staff']).map(staffFromJson).toList(),
          cursor: PageCursor.from(data['after_id'], data['after_time']),
          hasNext: readBool(data['has_next']),
        );
      });

  @override
  Future<Result<void>> register(String username, String password) =>
      guard(() => _api.post(ApiPaths.register, body: {'username': username, 'password': password}));

  @override
  Future<Result<void>> resetPassword(String id, String password) =>
      guard(() => _api.patch(ApiPaths.user(id), body: {'password': password}));

  @override
  Future<Result<void>> deactivate(String id) => guard(() => _api.delete(ApiPaths.user(id)));

  @override
  Future<Result<void>> restore(String id) => guard(() => _api.post(ApiPaths.userRestore(id)));

  @override
  Future<Result<PurgeMode>> purge(String id, {required String confirmUsername}) =>
      guard(() async => purgeModeFromJson(await _api.delete(ApiPaths.userPurge(id), body: {'confirm': confirmUsername})));
}
