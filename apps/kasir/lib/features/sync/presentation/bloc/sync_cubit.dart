import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/sync_usecases.dart';

part 'sync_cubit.freezed.dart';

@freezed
abstract class SyncState with _$SyncState {
  const factory SyncState({
    @Default(true) bool online,
    @Default(0) int pending,
    @Default(false) bool syncing,
    SyncReport? lastReport,
    Failure? failure,
    @Default(0) int reportId,
  }) = _SyncState;
}

/// Drives the offline banner and every sync trigger except the background task:
/// connection regained, app start, and the "Sync sekarang" button.
class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required this.sync,
    required this.refreshCatalog,
    required this.sales,
    required this.network,
    required this.scheduleNext,
  }) : super(const SyncState());

  final SyncPendingTransactions sync;
  final RefreshCatalog refreshCatalog;
  final SalesLog sales;
  final NetworkStatus network;
  final Future<void> Function() scheduleNext;

  StreamSubscription<int>? _pendingSub;
  StreamSubscription<bool>? _netSub;

  Future<void> start() async {
    _pendingSub = sales.watchPendingCount().listen((n) => emit(state.copyWith(pending: n)));
    final online = await network.isOnline();
    emit(state.copyWith(online: online));
    _netSub = network.watch().listen((online) {
      final regained = online && !state.online;
      emit(state.copyWith(online: online));
      if (regained) syncNow(quiet: true);
    });
    unawaited(scheduleNext().catchError((_) {}));
    if (online) {
      await refreshCatalog();
      await syncNow(quiet: true);
    }
  }

  /// [quiet] syncs do not produce a snackbar report.
  Future<void> syncNow({bool quiet = false}) async {
    if (state.syncing) return;
    emit(state.copyWith(syncing: true, failure: null));
    final result = await sync();
    emit(switch (result) {
      Ok(:final value) => state.copyWith(
          syncing: false,
          lastReport: quiet && value.synced == 0 ? state.lastReport : value,
          reportId: quiet && value.synced == 0 ? state.reportId : state.reportId + 1,
        ),
      Err(:final failure) => state.copyWith(syncing: false, failure: quiet ? null : failure, reportId: quiet ? state.reportId : state.reportId + 1),
    });
  }

  @override
  Future<void> close() async {
    await _pendingSub?.cancel();
    await _netSub?.cancel();
    return super.close();
  }
}
