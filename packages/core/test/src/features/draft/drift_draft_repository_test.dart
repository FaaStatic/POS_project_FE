import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

const indomie = Product(id: 'p1', sku: 'S1', name: 'Indomie', sellingPrice: 3500, sellingPriceDebt: 4000);
const pulsa = Product(id: 'p2', sku: 'S2', name: 'Pulsa 10k', sellingPrice: 11000, sellingPriceDebt: 12000, type: ProductType.digital);

void main() {
  late AppDatabase db;
  late DriftDraftRepository repo;
  var now = DateTime(2026, 10, 25, 9);

  setUp(() {
    now = DateTime(2026, 10, 25, 9);
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftDraftRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  test('tab numbers continue from the highest open tab and restart at 1', () async {
    final t1 = await repo.create();
    final t2 = await repo.create();
    expect([t1.number, t2.number], [1, 2]);
    await repo.delete(t1.id);
    expect((await repo.create()).number, 3);
    await repo.deleteAll();
    expect((await repo.create()).number, 1);
  });

  test('scanning the same physical product increases qty; digital adds a line', () async {
    final d = await repo.create();
    await repo.addProduct(d.id, indomie);
    await repo.addProduct(d.id, indomie);
    await repo.addProduct(d.id, pulsa);
    await repo.addProduct(d.id, pulsa);
    final draft = (await repo.byId(d.id))!;
    expect(draft.items.map((i) => i.qty), [2, 1, 1]);
    expect(draft.total(), 7000 + 22000);
    expect(draft.total(debt: true), 8000 + 24000);
    expect(draft.hasDigital, isTrue);
    expect(draft.items[1].missingDestination, isTrue);
  });

  test('qty, destination, removal, customer', () async {
    final d = await repo.create();
    await repo.addProduct(d.id, indomie);
    await repo.addProduct(d.id, pulsa);
    var draft = (await repo.byId(d.id))!;
    await repo.setQty(draft.items[0].id, 3);
    await repo.setDestination(draft.items[1].id, ' 0812 ');
    await repo.setCustomer(d.id, id: 'k1', name: 'Bu Sri');
    draft = (await repo.byId(d.id))!;
    expect(draft.items[0].qty, 3);
    expect(draft.items[1].destination, '0812');
    expect(draft.customerName, 'Bu Sri');
    await repo.setQty(draft.items[0].id, 0);
    expect((await repo.byId(d.id))!.items.single.productId, 'p2');
    await repo.removeItem(draft.items[1].id);
    expect((await repo.byId(d.id))!.isEmpty, isTrue);
  });

  test('awaiting payment stores the charge, reopen clears it, paid keeps sale ref', () async {
    final d = await repo.create();
    final charge = Charge(
      orderId: 'ORD-1',
      method: ChargeMethod.qris,
      state: PaymentState.pending,
      grossAmount: 7070,
      qrUrl: 'https://qr/1.png',
      expiresAt: DateTime.utc(2026, 10, 25, 9, 15),
    );
    await repo.markAwaiting(d.id, charge);
    var draft = (await repo.byId(d.id))!;
    expect(draft.isLocked, isTrue);
    expect(draft.charge, charge);
    await repo.reopen(d.id);
    draft = (await repo.byId(d.id))!;
    expect(draft.status, DraftStatus.open);
    expect(draft.charge, isNull);
    await repo.markPaid(d.id, 'ref-1');
    expect((await repo.byId(d.id))!.paidSaleRef, 'ref-1');
  });

  test('purge removes stale open drafts but keeps tabs waiting for payment', () async {
    final stale = await repo.create();
    final waiting = await repo.create();
    await repo.markAwaiting(waiting.id, const Charge(orderId: 'o', method: ChargeMethod.va, state: PaymentState.pending, grossAmount: 1));
    now = DateTime(2026, 10, 27);
    final fresh = await repo.create();
    final removed = await repo.purgeUntouchedSince(now.subtract(const Duration(hours: 24)));
    expect(removed, 1);
    expect((await repo.all()).map((d) => d.id), [waiting.id, fresh.id]);
    expect(await repo.byId(stale.id), isNull);
  });

  test('watchAll emits when items change', () async {
    final d = await repo.create();
    final emissions = repo.watchAll().map((ds) => ds.single.items.length);
    final expectation = expectLater(emissions, emitsThrough(1));
    await repo.addProduct(d.id, indomie);
    await expectation;
  });

  test('items of a deleted draft are removed with it', () async {
    final d = await repo.create();
    await repo.addProduct(d.id, indomie);
    await repo.delete(d.id);
    expect(await db.select(db.draftCartItems).get(), isEmpty);
  });
}
