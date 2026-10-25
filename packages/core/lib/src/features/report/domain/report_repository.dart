import '../../../common/failure.dart';
import '../../../common/result.dart';

abstract interface class ReportRepository {
  /// Fetches a generated PDF from its `/api/reports/...` path (needs the bearer token).
  Future<Result<List<int>>> download(String path);
}

class DownloadReport {
  const DownloadReport(this._repo);
  final ReportRepository _repo;

  Future<Result<List<int>>> call(String path) {
    if (!path.startsWith('/api/reports/')) return Future.value(const Err(ValidationFailure('invalid_report_path')));
    return _repo.download(path);
  }
}

/// File name for the browser download, from the server path.
String reportFileName(String path) => path.split('/').last;
