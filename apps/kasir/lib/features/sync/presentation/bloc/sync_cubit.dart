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
      // Queued sales and debt payments go first: the server does not know them yet, so a catalog pulled
      // before they are sent would show the old stock and debts again.
      await syncNow(quiet: true, pullCatalog: true);
    }
  }

  bool _refreshing = false;
  DateTime? _lastRefresh;

  /// Permission prompts, the scanner and file pickers also bring the app back to the front;
  /// the catalog is pulled at most this often.
  static const resumeGap = Duration(seconds: 30);

  /// The app is in front again: pull the catalog so products added elsewhere show up.
  /// Skipped offline, while a pull runs, and while sales wait to be sent, because the server
  /// stock does not include them yet. Lists skip the emit when nothing changed.
  Future<void> refreshOnResume() async {
    final last = _lastRefresh;
    if (!state.online || state.pending > 0 || state.syncing || _refreshing) return;
    if (last != null && DateTime.now().difference(last) < resumeGap) return;
    _refreshing = true;
    try {
      await refreshCatalog();
      _lastRefresh = DateTime.now();
    } finally {
      _refreshing = false;
    }
  }

  /// [quiet] syncs do not produce a snackbar report. [pullCatalog] is for a person asking to
  /// refresh (button, pull-to-refresh): products, categories and customers are re-read too, so
  /// an edit made in the CMS shows up. Sending sales alone only refreshes the catalog when some
  /// were accepted.
  Future<void> syncNow({bool quiet = false, bool pullCatalog = false}) async {
    if (state.syncing) return;
    emit(state.copyWith(syncing: true, failure: null));
    final result = await sync();
    // Sales still waiting are not in the server stock yet, so a pull now would undo them locally.
    // Sending sales already refreshes the catalog, so it is only pulled when nothing was sent.
    final report = result is Ok<SyncReport> ? result.value : null;
    final idle = report == null ? state.pending == 0 : report.remaining == 0;
    if (pullCatalog && state.online && idle) {
      if ((report?.synced ?? 0) == 0) await refreshCatalog();
      _lastRefresh = DateTime.now();
    }
    emit(switch (result) {
      Ok(:final value) => state.copyWith(
        syncing: false,
        lastReport: quiet && value.synced == 0 ? state.lastReport : value,
        reportId: quiet && value.synced == 0 ? state.reportId : state.reportId + 1,
      ),
      Err(:final failure) => state.copyWith(
        syncing: false,
        failure: quiet ? null : failure,
        reportId: quiet ? state.reportId : state.reportId + 1,
      ),
    });
  }

  @override
  Future<void> close() async {
    await _pendingSub?.cancel();
    await _netSub?.cancel();
    return super.close();
  }
}
