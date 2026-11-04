import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<bool> {
  ReportsCubit(this._month, this._debtRecap, this._download) : super(false);
  final GetMonthlyReportPdf _month;
  final GetDebtPaymentsRecapPdf _debtRecap;
  final DownloadReport _download;

  /// Generates the monthly PDF and returns its bytes and file name. State is "busy".
  Future<Result<(List<int>, String)>> monthly(int month, int year) => _fetch(() => _month(month, year));

  /// One table of every debt payment in the month, for all customers.
  Future<Result<(List<int>, String)>> debtRecap(int month, int year) => _fetch(() => _debtRecap(month, year));

  Future<Result<(List<int>, String)>> _fetch(Future<Result<String>> Function() generate) async {
    emit(true);
    final path = await generate();
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
