import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('downloads report bytes with the client and rejects foreign paths', () async {
    final adapter = FakeAdapter()..on('GET', '/insight/reports/oct.pdf', (_) => const FakeReply(200, [37, 80, 68, 70]));
    final download = DownloadReport(ReportRepositoryImpl(ApiClient(fakeDio(adapter))));
    expect((await download('/api/v1/insight/reports/oct.pdf') as Ok<List<int>>).value, isNotEmpty);
    expect(await download('https://evil.test/x.pdf'), const Err<List<int>>(ValidationFailure('invalid_report_path')));
    expect(await download('/api/reports/oct.pdf'), const Err<List<int>>(ValidationFailure('invalid_report_path')));
    expect(await download('/api/v1/insight/reports/../secret'), const Err<List<int>>(ValidationFailure('invalid_report_path')));
    expect(reportFileName('/api/v1/insight/reports/oct.pdf'), 'oct.pdf');
  });

  test('the report path is relative to the API root and ignores the version the server used', () {
    expect(ApiPaths.reportFile('/api/v1/insight/reports/a.pdf'), '/insight/reports/a.pdf');
    expect(ApiPaths.reportFile('/api/v12/insight/reports/a.pdf'), '/insight/reports/a.pdf');
    expect(ApiPaths.reportFile('/api/v1/sales/reports/a.pdf'), isNull);
    expect(ApiPaths.reportFile('/insight/reports/a.pdf'), isNull);
    expect(ApiPaths.reportFile(''), isNull);
    expect(ApiPaths.reportFile('/api/v1/insight/reports/..'), isNull);
  });
}
