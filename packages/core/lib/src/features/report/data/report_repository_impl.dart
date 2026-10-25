import '../../../common/guard.dart';
import '../../../common/result.dart';
import '../../../network/api_client.dart';
import '../domain/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<Result<List<int>>> download(String path) => guard(() => _api.bytes(path));
}
