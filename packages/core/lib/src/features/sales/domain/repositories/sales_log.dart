import '../entities/sale.dart';

abstract interface class SalesLog {
  Future<void> add(Sale sale);

  /// Newest first.
  Stream<List<Sale>> watchAll({int limit = 200});
  Stream<int> watchPendingCount();

  /// Oldest first, so the server sees sales in the order they happened.
  Future<List<Sale>> pending({int limit = 100});
  Future<Sale?> byRef(String clientRef);
  Future<Sale?> byTransactionId(String transactionId);

  Future<void> markSynced(String clientRef, {String? transactionId, String? invoice, bool stockConflict = false});

  /// Retryable errors stay in the queue with the reason; others leave the automatic queue.
  Future<void> markFailed(String clientRef, String error, {required bool retryable});
  Future<void> markCancelled(String clientRef, String reason);

  /// `OFF-<deviceCode>-<seq>`, unique per device.
  Future<String> nextOfflineNumber();
}
