import 'package:core/core.dart';

class WatchSales {
  const WatchSales(this._sales);
  final SalesLog _sales;

  Stream<List<Sale>> call() => _sales.watchAll();
}

class GetSale {
  const GetSale(this._sales);
  final SalesLog _sales;

  Future<Sale?> call(String clientRef) => _sales.byRef(clientRef);
}

/// Unsynced sales are cancelled locally (no connection needed) and their stock
/// returned; synced ones are cancelled on the server first.
class CancelSale {
  const CancelSale(this._sales, this._transactions, this._cache);
  final SalesLog _sales;
  final CancelTransaction _transactions;
  final CatalogCache _cache;

  Future<Result<void>> call(Sale sale, String reason) async {
    if (Validators.cancelReason(reason) != null) return const Err(ValidationFailure('reason_length'));
    if (sale.status == SaleStatus.cancelled) return const Ok(null);
    if (sale.isSynced) {
      final id = sale.transactionId;
      if (id == null) return const Err(NotFoundFailure());
      final result = await _transactions(id, reason);
      if (result case Err()) return result;
    }
    await _sales.markCancelled(sale.clientRef, reason.trim());
    await _cache.adjustStock({for (final l in sale.lines) l.productId: l.qty});
    return const Ok(null);
  }
}
