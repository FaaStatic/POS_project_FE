import 'dart:async';

import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactions extends Mock implements TransactionRepository {}

class MockPayments extends Mock implements PaymentRepository {}

class MockProducts extends Mock implements ProductRepository {}

class MockCategories extends Mock implements CategoryRepository {}

class MockCustomers extends Mock implements CustomerRepository {}

class MockAuth extends Mock implements AuthRepository {}

class FakeNetwork implements NetworkStatus {
  FakeNetwork([this.online = true]);
  bool online;
  final _changes = StreamController<bool>.broadcast();

  /// Flips connectivity and notifies watchers, like a real reconnect.
  void set(bool value) {
    online = value;
    _changes.add(value);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> watch() => _changes.stream;
}

const staff = Session(userId: 'u1', username: 'kasir1', role: UserRole.staff);

const indomie = Product(id: 'p1', sku: 'S1', barcode: '899', name: 'Indomie Goreng', sellingPrice: 3500, sellingPriceDebt: 4000, stock: 10);
const aqua = Product(id: 'p2', sku: 'S2', name: 'Aqua 600ml', sellingPrice: 4000, sellingPriceDebt: 4500, stock: 1);
const pulsa = Product(id: 'p3', sku: 'S3', name: 'Pulsa 10rb', sellingPrice: 11000, sellingPriceDebt: 12000, type: ProductType.digital);

/// Real drift tables in memory plus the local repositories built on them.
class LocalFixture {
  LocalFixture() : db = AppDatabase(NativeDatabase.memory()) {
    store = MemoryStore();
    cache = DriftCatalogCache(db);
    sales = DriftSalesLog(db, store);
    drafts = DriftDraftRepository(db);
  }

  final AppDatabase db;
  late final MemoryStore store;
  late final DriftCatalogCache cache;
  late final DriftSalesLog sales;
  late final DriftDraftRepository drafts;

  Future<void> seed() => cache.replaceProducts(const [indomie, aqua, pulsa]);

  Future<Draft> draftWith(List<(Product, double)> items, {String? customerId, String? customerName}) async {
    final d = await drafts.create();
    for (final (p, q) in items) {
      await drafts.addProduct(d.id, p, qty: q);
    }
    if (customerId != null) await drafts.setCustomer(d.id, id: customerId, name: customerName);
    return (await drafts.byId(d.id))!;
  }

  Future<void> close() => db.close();
}

void registerFallbacks() {
  registerFallbackValue(const CheckoutRequest(userId: '', method: PaymentMethod.cash, lines: []));
  registerFallbackValue(<OfflineSale>[]);
}
