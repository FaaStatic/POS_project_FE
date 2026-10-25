import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../common/json.dart';
import '../../../database/app_database.dart';
import '../../payment/domain/entities/payment.dart';
import '../../product/domain/entities/product.dart';
import '../domain/entities/draft.dart';
import '../domain/repositories/draft_repository.dart';

class DriftDraftRepository implements DraftRepository {
  DriftDraftRepository(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  @override
  Stream<List<Draft>> watchAll() {
    final carts = _db.select(_db.draftCarts)..orderBy([(c) => OrderingTerm.asc(c.number)]);
    // Re-read items whenever either table changes.
    return carts.watch().asyncMap((_) => all());
  }

  @override
  Future<List<Draft>> all() async {
    final carts = await (_db.select(_db.draftCarts)..orderBy([(c) => OrderingTerm.asc(c.number)])).get();
    final items = await (_db.select(_db.draftCartItems)..orderBy([(i) => OrderingTerm.asc(i.position)])).get();
    return [for (final c in carts) _draft(c, items.where((i) => i.draftId == c.id))];
  }

  @override
  Future<Draft?> byId(int id) async {
    final cart = await (_db.select(_db.draftCarts)..where((c) => c.id.equals(id))).getSingleOrNull();
    if (cart == null) return null;
    final items = await (_db.select(_db.draftCartItems)
          ..where((i) => i.draftId.equals(id))
          ..orderBy([(i) => OrderingTerm.asc(i.position)]))
        .get();
    return _draft(cart, items);
  }

  @override
  Future<Draft> create() => _db.transaction(() async {
        final max = _db.draftCarts.number.max();
        final highest = await (_db.selectOnly(_db.draftCarts)..addColumns([max])).map((r) => r.read(max)).getSingle();
        final now = _clock();
        final id = await _db.into(_db.draftCarts).insert(
              DraftCartsCompanion.insert(number: (highest ?? 0) + 1, createdAt: now, updatedAt: now),
            );
        return (await byId(id))!;
      });

  @override
  Future<void> addProduct(int draftId, Product product, {double qty = 1}) => _db.transaction(() async {
        final existing = product.isDigital
            ? null
            : await (_db.select(_db.draftCartItems)
                  ..where((i) => i.draftId.equals(draftId) & i.productId.equals(product.id)))
                .getSingleOrNull();
        if (existing != null) {
          await (_db.update(_db.draftCartItems)..where((i) => i.id.equals(existing.id)))
              .write(DraftCartItemsCompanion(qty: Value(existing.qty + qty)));
        } else {
          final pos = _db.draftCartItems.position.max();
          final last = await (_db.selectOnly(_db.draftCartItems)
                ..addColumns([pos])
                ..where(_db.draftCartItems.draftId.equals(draftId)))
              .map((r) => r.read(pos))
              .getSingle();
          await _db.into(_db.draftCartItems).insert(DraftCartItemsCompanion.insert(
                draftId: draftId,
                productId: product.id,
                name: product.name,
                unitPrice: product.sellingPrice,
                debtPrice: product.sellingPriceDebt,
                qty: qty,
                unit: Value(product.unit.index),
                isDigital: Value(product.isDigital),
                position: (last ?? -1) + 1,
              ));
        }
        await _touch(draftId);
      });

  @override
  Future<void> setQty(int itemId, double qty) async {
    if (qty <= 0) return removeItem(itemId);
    final item = await _item(itemId);
    if (item == null) return;
    await (_db.update(_db.draftCartItems)..where((i) => i.id.equals(itemId))).write(DraftCartItemsCompanion(qty: Value(qty)));
    await _touch(item.draftId);
  }

  @override
  Future<void> removeItem(int itemId) async {
    final item = await _item(itemId);
    if (item == null) return;
    await (_db.delete(_db.draftCartItems)..where((i) => i.id.equals(itemId))).go();
    await _touch(item.draftId);
  }

  @override
  Future<void> setDestination(int itemId, String destination) async {
    final item = await _item(itemId);
    if (item == null) return;
    await (_db.update(_db.draftCartItems)..where((i) => i.id.equals(itemId)))
        .write(DraftCartItemsCompanion(destination: Value(destination.trim())));
    await _touch(item.draftId);
  }

  @override
  Future<void> setCustomer(int draftId, {String? id, String? name}) =>
      (_db.update(_db.draftCarts)..where((c) => c.id.equals(draftId))).write(DraftCartsCompanion(
        customerId: Value(id),
        customerName: Value(name),
        updatedAt: Value(_clock()),
      ));

  @override
  Future<void> markAwaiting(int draftId, Charge charge) =>
      (_db.update(_db.draftCarts)..where((c) => c.id.equals(draftId))).write(DraftCartsCompanion(
        status: Value(DraftStatus.awaitingPayment.index),
        chargeJson: Value(jsonEncode(_chargeToJson(charge))),
        updatedAt: Value(_clock()),
      ));

  @override
  Future<void> reopen(int draftId) =>
      (_db.update(_db.draftCarts)..where((c) => c.id.equals(draftId))).write(DraftCartsCompanion(
        status: Value(DraftStatus.open.index),
        chargeJson: const Value(null),
        updatedAt: Value(_clock()),
      ));

  @override
  Future<void> markPaid(int draftId, String saleRef) =>
      (_db.update(_db.draftCarts)..where((c) => c.id.equals(draftId))).write(DraftCartsCompanion(
        status: Value(DraftStatus.paid.index),
        paidSaleRef: Value(saleRef),
        updatedAt: Value(_clock()),
      ));

  @override
  Future<void> delete(int draftId) => (_db.delete(_db.draftCarts)..where((c) => c.id.equals(draftId))).go();

  @override
  Future<void> deleteAll() => _db.delete(_db.draftCarts).go();

  @override
  Future<int> purgeUntouchedSince(DateTime olderThan) => (_db.delete(_db.draftCarts)
        ..where((c) => c.updatedAt.isSmallerThanValue(olderThan) & c.status.equals(DraftStatus.awaitingPayment.index).not()))
      .go();

  Future<DraftCartItem?> _item(int id) =>
      (_db.select(_db.draftCartItems)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<void> _touch(int draftId) => (_db.update(_db.draftCarts)..where((c) => c.id.equals(draftId)))
      .write(DraftCartsCompanion(updatedAt: Value(_clock())));

  static Draft _draft(DraftCart c, Iterable<DraftCartItem> items) => Draft(
        id: c.id,
        number: c.number,
        customerId: c.customerId,
        customerName: c.customerName,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
        status: DraftStatus.values[c.status],
        charge: c.chargeJson == null ? null : _chargeFromJson(jsonDecode(c.chargeJson!) as Map<String, dynamic>),
        paidSaleRef: c.paidSaleRef,
        items: [
          for (final i in items)
            DraftItem(
              id: i.id,
              productId: i.productId,
              name: i.name,
              unitPrice: i.unitPrice,
              debtPrice: i.debtPrice,
              qty: i.qty,
              unit: i.unit,
              isDigital: i.isDigital,
              destination: i.destination,
            ),
        ],
      );

  static Map<String, dynamic> _chargeToJson(Charge c) => {
        'order_id': c.orderId,
        'method': c.method.name,
        'status': c.state.name,
        'gross_amount': c.grossAmount,
        'qr_string': ?c.qrString,
        'qr_url': ?c.qrUrl,
        'va_number': ?c.vaNumber,
        'bank': ?c.bank,
        'bill_key': ?c.billKey,
        'biller_code': ?c.billerCode,
        'expiry_time': ?c.expiresAt?.toUtc().toIso8601String(),
      };

  static Charge _chargeFromJson(Map<String, dynamic> j) => Charge(
        orderId: readString(j['order_id']),
        method: readString(j['method']) == 'va' ? ChargeMethod.va : ChargeMethod.qris,
        state: PaymentState.parse(readString(j['status'])),
        grossAmount: readInt(j['gross_amount']),
        qrString: readNullableString(j['qr_string']),
        qrUrl: readNullableString(j['qr_url']),
        vaNumber: readNullableString(j['va_number']),
        bank: readNullableString(j['bank']),
        billKey: readNullableString(j['bill_key']),
        billerCode: readNullableString(j['biller_code']),
        expiresAt: readDate(j['expiry_time']),
      );
}
