import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('downloads report bytes with the client and rejects foreign paths', () async {
    final adapter = FakeAdapter()..on('GET', '/api/reports/oct.pdf', (_) => const FakeReply(200, [37, 80, 68, 70]));
    final download = DownloadReport(ReportRepositoryImpl(ApiClient(fakeDio(adapter))));
    expect((await download('/api/reports/oct.pdf') as Ok<List<int>>).value, isNotEmpty);
    expect(await download('https://evil.test/x.pdf'), const Err<List<int>>(ValidationFailure('invalid_report_path')));
    expect(reportFileName('/api/reports/oct.pdf'), 'oct.pdf');
  });
}
