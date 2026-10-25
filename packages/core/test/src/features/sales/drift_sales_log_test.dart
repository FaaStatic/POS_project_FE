import 'dart:math';

import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

Sale sale(String ref, {DateTime? at, SaleStatus status = SaleStatus.pending}) => Sale(
      clientRef: ref,
      receiptNumber: 'OFF-ABCD-1',
      createdAt: at ?? DateTime(2026, 10, 25, 9),
      method: PaymentMethod.cash,
      cashierName: 'kasir',
      total: 7000,
      lines: const [SaleLine(productId: 'p1', name: 'Indomie', qty: 2, unitPrice: 3500, destination: '0812')],
      status: status,
    );

void main() {
  late AppDatabase db;
  late DriftSalesLog log;
  late MemoryStore store;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    store = MemoryStore();
    log = DriftSalesLog(db, store, random: Random(1));
  });
  tearDown(() => db.close());

  test('stores and reads a sale with its lines', () async {
    await log.add(sale('a'));
    final s = (await log.byRef('a'))!;
    expect(s.lines.single.destination, '0812');
    expect(s.lines.single.subtotal, 7000);
    expect(s.isOffline, isTrue);
  });

  test('pending is oldest first and excludes other statuses', () async {
    await log.add(sale('late', at: DateTime(2026, 10, 25, 12)));
    await log.add(sale('early', at: DateTime(2026, 10, 25, 8)));
    await log.add(sale('done', status: SaleStatus.synced));
    expect((await log.pending()).map((s) => s.clientRef), ['early', 'late']);
    expect(await log.watchPendingCount().first, 2);
  });

  test('markSynced replaces the receipt number with the invoice', () async {
    await log.add(sale('a'));
    await log.markSynced('a', transactionId: 't1', invoice: 'INV-7', stockConflict: true);
    final s = (await log.byTransactionId('t1'))!;
    expect(s.receiptNumber, 'INV-7');
    expect(s.isSynced, isTrue);
    expect(s.stockConflict, isTrue);
  });

  test('failed: retryable stays pending with reason, others leave the queue', () async {
    await log.add(sale('a'));
    await log.add(sale('b'));
    await log.markFailed('a', 'timeout', retryable: true);
    await log.markFailed('b', 'product deleted', retryable: false);
    expect((await log.pending()).map((s) => s.clientRef), ['a']);
    expect((await log.byRef('a'))!.error, 'timeout');
    expect((await log.byRef('b'))!.status, SaleStatus.failed);
  });

  test('cancel keeps the record with its reason', () async {
    await log.add(sale('a'));
    await log.markCancelled('a', 'salah input');
    expect((await log.byRef('a'))!.cancelReason, 'salah input');
    expect(await log.pending(), isEmpty);
    expect((await log.watchAll().first).single.status, SaleStatus.cancelled);
  });

  test('offline numbers keep one device code and count up', () async {
    final first = await log.nextOfflineNumber();
    final second = await log.nextOfflineNumber();
    expect(first, matches(RegExp(r'^OFF-[A-Z2-9]{4}-1$')));
    expect(second, '${first.substring(0, 8)}-2');
  });
}
