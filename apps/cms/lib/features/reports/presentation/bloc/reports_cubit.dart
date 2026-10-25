import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<bool> {
  ReportsCubit(this._month, this._download) : super(false);
  final GetMonthlyReportPdf _month;
  final DownloadReport _download;

  /// Generates the monthly PDF and returns its bytes and file name. State is "busy".
  Future<Result<(List<int>, String)>> monthly(int month, int year) async {
    emit(true);
    final path = await _month(month, year);
    final Result<(List<int>, String)> result = switch (path) {
      Ok(:final value) => switch (await _download(value)) {
          Ok(value: final bytes) => Ok((bytes, reportFileName(value))),
          Err(:final failure) => Err(failure),
        },
      Err(:final failure) => Err(failure),
    };
    emit(false);
    return result;
  }
}
