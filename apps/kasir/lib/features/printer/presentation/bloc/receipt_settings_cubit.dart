import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Store info, paper width, printer, and auto-print preferences.
class ReceiptSettingsCubit extends Cubit<ReceiptSettings> {
  ReceiptSettingsCubit(this._get, this._save) : super(_get());
  final GetReceiptSettings _get;
  final SaveReceiptSettings _save;
  StreamSubscription<ReceiptSettings>? _sub;

  void start() => _sub = _get.watch().listen(emit);

  Future<void> save(ReceiptSettings settings) => _save(settings);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
