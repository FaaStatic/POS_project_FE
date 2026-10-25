import 'package:workmanager/workmanager.dart';

import '../domain/usecases/sync_usecases.dart';

/// Schedules the 12:00 / 00:00 background sync as a one-off task that
/// reschedules itself. Android may shift it; iOS runs it when the OS allows.
class SyncScheduler {
  const SyncScheduler([this._clock = DateTime.now]);
  final DateTime Function() _clock;

  static const taskName = 'com.suhaili.cashier.sync';

  Future<void> scheduleNext() {
    final now = _clock();
    return Workmanager().registerOneOffTask(
      taskName,
      taskName,
      initialDelay: nextSyncSlot(now).difference(now),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
