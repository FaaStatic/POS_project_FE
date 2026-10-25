import 'package:core/core.dart';
import 'package:uuid/uuid.dart';

/// Opens a new "Transaksi N" tab.
class OpenDraft {
  const OpenDraft(this._drafts);
  final DraftRepository _drafts;

  Future<Draft> call() => _drafts.create();
}

/// Discards a tab. Tabs waiting for QRIS/VA cannot be closed.
class CloseDraft {
  const CloseDraft(this._drafts);
  final DraftRepository _drafts;

  Future<Result<void>> call(Draft draft) async {
    if (draft.status == DraftStatus.awaitingPayment) return const Err(ConflictFailure('awaiting_payment'));
    await _drafts.delete(draft.id);
    return const Ok(null);
  }
}

class AddItem {
  const AddItem(this._drafts);
  final DraftRepository _drafts;

  Future<Result<void>> call(Draft draft, Product product, {double qty = 1}) async {
    if (draft.isLocked) return const Err(ConflictFailure('draft_locked'));
    await _drafts.addProduct(draft.id, product, qty: qty);
    return const Ok(null);
  }
}

sealed class ScanOutcome {
  const ScanOutcome();
}

final class ScanAdded extends ScanOutcome {
  const ScanAdded(this.product);
  final Product product;
}

final class ScanUnknown extends ScanOutcome {
  const ScanUnknown(this.code);
  final String code;
}

final class ScanLocked extends ScanOutcome {
  const ScanLocked();
}

/// Looks the code up in the local cache so scanning works offline.
class ScanBarcode {
  const ScanBarcode(this._cache, this._addItem);
  final CatalogCache _cache;
  final AddItem _addItem;

  Future<ScanOutcome> call(Draft draft, String code) async {
    final product = await _cache.productByBarcode(code.trim());
    if (product == null) return ScanUnknown(code.trim());
    return switch (await _addItem(draft, product)) {
      Ok() => ScanAdded(product),
      Err() => const ScanLocked(),
    };
  }
}

/// Deletes tabs untouched for 24 hours; returns how many were removed.
class PurgeStaleDrafts {
  const PurgeStaleDrafts(this._drafts, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;
  final DraftRepository _drafts;
  final DateTime Function() _clock;

  Future<int> call() => _drafts.purgeUntouchedSince(_clock().subtract(const Duration(hours: 24)));
}

class CheckoutOutcome {
  const CheckoutOutcome(this.sale, {required this.offline});
  final Sale sale;
  final bool offline;
}

/// Cash and debt checkout. Online sales go straight to the server; offline ones
/// (or when the request could not even connect) are queued with a client_ref.
/// A timeout is NOT queued: the server may have recorded the sale already, and
/// POST /api/transactions has no idempotency key.
class CheckoutTransaction {
  CheckoutTransaction({
    required this.transactions,
    required this.sales,
    required this.drafts,
    required this.cache,
    required this.network,
    required this.session,
    DateTime Function()? clock,
    String Function()? newRef,
  })  : _clock = clock ?? DateTime.now,
        _newRef = newRef ?? const Uuid().v4;

  final TransactionRepository transactions;
  final SalesLog sales;
  final DraftRepository drafts;
  final CatalogCache cache;
  final NetworkStatus network;
  final GetCurrentSession session;
  final DateTime Function() _clock;
  final String Function() _newRef;

  Future<Result<CheckoutOutcome>> call(Draft draft, PaymentMethod method) async {
    final user = session();
    if (user == null) return const Err(UnauthorizedFailure());
    if (!method.worksOffline) return const Err(ValidationFailure('use_charge'));
    if (draft.isLocked) return const Err(ConflictFailure('draft_locked'));
    final debt = method == PaymentMethod.debt;
    final lines = [
      for (final i in draft.items)
        CheckoutLine(productId: i.productId, qty: i.qty, unitPrice: i.price(debt: debt), destination: i.isDigital ? i.destination ?? '' : null),
    ];
    final invalid = validateCheckout(method, draft.customerId, lines);
    if (invalid != null) return Err(ValidationFailure(invalid));

    Sale sale(String number, {String? transactionId, int? total, bool conflict = false, SaleStatus status = SaleStatus.pending}) => Sale(
          clientRef: _newRef(),
          receiptNumber: number,
          createdAt: _clock(),
          method: method,
          customerId: draft.customerId,
          customerName: draft.customerName,
          cashierName: user.username,
          total: total ?? draft.total(debt: debt),
          lines: [
            for (final i in draft.items)
              SaleLine(productId: i.productId, name: i.name, qty: i.qty, unitPrice: i.price(debt: debt), destination: i.isDigital ? i.destination : null),
          ],
          status: status,
          transactionId: transactionId,
          stockConflict: conflict,
        );

    if (await network.isOnline()) {
      final result = await transactions.create(
        CheckoutRequest(userId: user.userId, method: method, customerId: draft.customerId, lines: lines),
      );
      switch (result) {
        case Ok(:final value):
          final recorded = sale(value.invoice,
              transactionId: value.transactionId, total: value.total, conflict: value.stockConflict, status: SaleStatus.synced);
          await _commit(draft, recorded);
          return Ok(CheckoutOutcome(recorded, offline: false));
        case Err(failure: NetworkFailure()):
          break;
        case Err(:final failure):
          return Err(failure);
      }
    }

    final queued = sale(await sales.nextOfflineNumber());
    await _commit(draft, queued);
    return Ok(CheckoutOutcome(queued, offline: true));
  }

  Future<void> _commit(Draft draft, Sale sale) async {
    await sales.add(sale);
    await cache.adjustStock({for (final l in sale.lines) l.productId: -l.qty}, countSale: true);
    await drafts.delete(draft.id);
  }
}

/// Creates a QRIS or VA charge for a tab and locks it until the charge settles.
class StartCharge {
  const StartCharge({required this.qris, required this.va, required this.drafts, required this.network, required this.session});
  final ChargeQris qris;
  final ChargeVa va;
  final DraftRepository drafts;
  final NetworkStatus network;
  final GetCurrentSession session;

  Future<Result<Charge>> call(Draft draft, ChargeMethod method, {VaBank bank = VaBank.bca}) async {
    final user = session();
    if (user == null) return const Err(UnauthorizedFailure());
    if (draft.isLocked) return const Err(ConflictFailure('draft_locked'));
    if (draft.isEmpty) return const Err(ValidationFailure('empty_cart'));
    // QRIS/VA charges carry no destination, so digital products would lose it.
    if (draft.hasDigital) return const Err(ValidationFailure('digital_needs_cash'));
    if (!await network.isOnline()) return const Err(NetworkFailure());
    final items = [for (final i in draft.items) ChargeItem(i.productId, i.qty)];
    final result = method == ChargeMethod.qris
        ? await qris(userId: user.userId, customerId: draft.customerId, items: items)
        : await va(userId: user.userId, customerId: draft.customerId, bank: bank, items: items);
    if (result case Ok(:final value)) await drafts.markAwaiting(draft.id, value);
    return result;
  }
}

enum ChargeResolution { pending, paid, failed }

/// Checks a waiting tab's charge. Paid: records the sale and keeps the tab as a
/// receipt. Failed or expired: unlocks the tab so another method can be chosen.
class ResolveCharge {
  ResolveCharge({
    required this.status,
    required this.transactions,
    required this.sales,
    required this.drafts,
    required this.cache,
    required this.session,
    DateTime Function()? clock,
    String Function()? newRef,
  })  : _clock = clock ?? DateTime.now,
        _newRef = newRef ?? const Uuid().v4;

  final CheckPaymentStatus status;
  final TransactionRepository transactions;
  final SalesLog sales;
  final DraftRepository drafts;
  final CatalogCache cache;
  final GetCurrentSession session;
  final DateTime Function() _clock;
  final String Function() _newRef;

  Future<ChargeResolution> call(Draft draft) async {
    final charge = draft.charge;
    if (draft.status != DraftStatus.awaitingPayment || charge == null) return ChargeResolution.pending;
    final result = await status(charge.orderId);
    if (result case Err()) return ChargeResolution.pending;
    final state = (result as Ok<ChargeStatus>).value;
    if (state.state == PaymentState.failed || state.state == PaymentState.expired) {
      await drafts.reopen(draft.id);
      return ChargeResolution.failed;
    }
    final transactionId = state.transactionId;
    if (state.state != PaymentState.success || transactionId == null) return ChargeResolution.pending;

    final existing = await sales.byTransactionId(transactionId);
    if (existing != null) {
      await drafts.markPaid(draft.id, existing.clientRef);
      return ChargeResolution.paid;
    }
    final trx = await transactions.get(transactionId);
    final invoice = switch (trx) {
      Ok(:final value) => value.invoice,
      Err() => charge.orderId,
    };
    final sale = Sale(
      clientRef: _newRef(),
      receiptNumber: invoice,
      createdAt: state.paidAt?.toLocal() ?? _clock(),
      method: charge.method == ChargeMethod.qris ? PaymentMethod.qris : PaymentMethod.va,
      customerId: draft.customerId,
      customerName: draft.customerName,
      cashierName: session()?.username ?? '',
      total: state.grossAmount,
      lines: [for (final i in draft.items) SaleLine(productId: i.productId, name: i.name, qty: i.qty, unitPrice: i.unitPrice)],
      status: SaleStatus.synced,
      transactionId: transactionId,
    );
    await sales.add(sale);
    await cache.adjustStock({for (final l in sale.lines) l.productId: -l.qty}, countSale: true);
    await drafts.markPaid(draft.id, sale.clientRef);
    return ChargeResolution.paid;
  }
}

/// Lines whose quantity exceeds the cached stock (another tab may have sold it).
class FindStockShortfalls {
  const FindStockShortfalls(this._cache);
  final CatalogCache _cache;

  /// Product id → stock left, for lines that want more than that.
  Future<Map<String, double>> call(Draft draft) async {
    final physical = draft.items.where((i) => !i.isDigital).toList();
    if (physical.isEmpty) return const {};
    final stock = await _cache.stockOf(physical.map((i) => i.productId));
    final wanted = <String, double>{};
    for (final i in physical) {
      wanted[i.productId] = (wanted[i.productId] ?? 0) + i.qty;
    }
    return {for (final e in wanted.entries) if (e.value > (stock[e.key] ?? 0)) e.key: stock[e.key] ?? 0};
  }
}
