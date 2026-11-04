import '../../../common/failure.dart';
import '../../../common/result.dart';
import '../../../constants/api_paths.dart';

abstract interface class ReportRepository {
  /// Fetches a generated PDF from its path relative to the API root, `/insight/reports/...`
  /// (needs the bearer token).
  Future<Result<List<int>>> download(String path);
}

class DownloadReport {
  const DownloadReport(this._repo);
  final ReportRepository _repo;

  /// [path] is the absolute `url_pdf` the server returned, e.g. `/api/v1/insight/reports/x.pdf`.
  Future<Result<List<int>>> call(String path) {
    final relative = ApiPaths.reportFile(path);
    if (relative == null) return Future.value(const Err(ValidationFailure('invalid_report_path')));
    return _repo.download(relative);
  }
}

/// File name for the browser download, from the server path.
String reportFileName(String path) => path.split('/').last;
