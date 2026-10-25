import '../../../payment/domain/entities/payment.dart';
import '../../../product/domain/entities/product.dart';
import '../entities/draft.dart';

abstract interface class DraftRepository {
  /// Ordered by tab number.
  Stream<List<Draft>> watchAll();
  Future<List<Draft>> all();
  Future<Draft?> byId(int id);

  /// Number = highest open number + 1, or 1 when no tab is open.
  Future<Draft> create();

  /// Physical products merge into one line; digital products always get a new
  /// line because each needs its own destination.
  Future<void> addProduct(int draftId, Product product, {double qty = 1});
  Future<void> setQty(int itemId, double qty);
  Future<void> removeItem(int itemId);
  Future<void> setDestination(int itemId, String destination);
  Future<void> setCustomer(int draftId, {String? id, String? name});

  Future<void> markAwaiting(int draftId, Charge charge);
  Future<void> reopen(int draftId);
  Future<void> markPaid(int draftId, String saleRef);
  Future<void> delete(int draftId);
  Future<void> deleteAll();

  /// Deletes open drafts untouched since [olderThan]; tabs waiting for payment stay.
  Future<int> purgeUntouchedSince(DateTime olderThan);
}
