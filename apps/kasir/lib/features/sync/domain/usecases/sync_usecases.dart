import 'package:core/core.dart';

class SyncReport {
  const SyncReport({this.synced = 0, this.failed = 0, this.conflicts = 0, this.remaining = 0});
  final int synced;
  final int failed;
  final int conflicts;
  final int remaining;
}

/// Sends queued offline sales in batches of 100, then the queued debt payments one by one.
/// Each item is settled on its own: accepted sales take the server invoice, rejected ones keep
/// their reason. A debt payment's receipt number is its idempotency key, so a resend after a
/// lost response is not paid twice.
class SyncPendingTransactions {
  const SyncPendingTransactions(this._sales, this._transactions, this._debts, this._session, this._refresh);
  final SalesLog _sales;
  final TransactionRepository _transactions;
  final DebtRepository _debts;
  final GetCurrentSession _session;
  final RefreshCatalog _refresh;

  static const batchSize = 100;

  Future<Result<SyncReport>> call() async {
    var synced = 0, failed = 0, conflicts = 0;
    final seen = <String>{};
    while (true) {
      final batch = (await _sales.pending(limit: batchSize, kind: SaleKind.sale)).where((s) => seen.add(s.clientRef)).toList();
      if (batch.isEmpty) break;
      final result = await _transactions.sync([
        for (final s in batch)
          OfflineSale(
            clientRef: s.clientRef,
            createdAt: s.createdAt,
            method: s.method,
            customerId: s.customerId,
            amountPaid: s.amountPaid,
            change: s.change,
            lines: [
              for (final l in s.lines)
                CheckoutLine(productId: l.productId, qty: l.qty, unitPrice: l.unitPrice, destination: l.destination),
            ],
          ),
      ]);
      if (result case Err(:final failure)) {
        if (synced == 0 && failed == 0) return Err(failure);
        break;
      }
      final byRef = {for (final r in (result as Ok<List<SyncResult>>).value) r.clientRef: r};
      for (final sale in batch) {
        final r = byRef[sale.clientRef];
        if (r == null) {
          await _sales.markFailed(sale.clientRef, 'no_result', retryable: true);
          failed++;
        } else if (r.accepted) {
          await _sales.markSynced(
            sale.clientRef,
            transactionId: r.transactionId,
            invoice: r.invoice,
            stockConflict: r.stockConflict,
            debtBefore: r.debtBefore,
            debtAfter: r.debtAfter,
          );
          synced++;
          if (r.stockConflict) conflicts++;
        } else {
          await _sales.markFailed(sale.clientRef, r.error ?? 'failed', retryable: r.retryable);
          failed++;
        }
      }
      if (batch.length < batchSize) break;
    }
    final (paid, rejected) = await _sendDebtPayments();
    synced += paid;
    failed += rejected;
    // Server stock and debts moved; refresh the cache so the next sale sees them.
    if (synced > 0) await _refresh();
    final remaining = (await _sales.pending()).length;
    return Ok(SyncReport(synced: synced, failed: failed, conflicts: conflicts, remaining: remaining));
  }

  /// Stops at the first failure that a later try could fix (no connection, server down, expired login).
  Future<(int, int)> _sendDebtPayments() async {
    final user = _session();
    if (user == null) return (0, 0);
    var paid = 0, rejected = 0;
    for (final sale in await _sales.pending(kind: SaleKind.debtPayment)) {
      final result = await _debts.pay(
        debtId: sale.debtId ?? '',
        userId: user.userId,
        amount: sale.total,
        idempotencyKey: sale.receiptNumber,
      );
      switch (result) {
        case Ok():
          await _sales.markSynced(sale.clientRef);
          paid++;
        case Err(failure: NetworkFailure() || ServerFailure() || UnauthorizedFailure()):
          return (paid, rejected);
        case Err(:final failure):
          await _sales.markFailed(sale.clientRef, failure.message ?? 'failed', retryable: false);
          rejected++;
      }
    }
    return (paid, rejected);
  }
}

/// Next 12:00 or 00:00 device time after [now].
DateTime nextSyncSlot(DateTime now) {
  final noon = DateTime(now.year, now.month, now.day, 12);
  if (now.isBefore(noon)) return noon;
  return DateTime(now.year, now.month, now.day + 1);
}
