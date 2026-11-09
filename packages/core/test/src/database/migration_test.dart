import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a v1 database upgrades to the latest schema keeping its sales and tabs, gaining cash, change and debt columns', () async {
    // The `sales` table exactly as schema version 1 created it, with one sale already in it.
    final executor = NativeDatabase.memory(
      setup: (raw) {
        raw.execute('''
          CREATE TABLE sales (
            client_ref TEXT NOT NULL PRIMARY KEY,
            receipt_number TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            method INTEGER NOT NULL,
            customer_id TEXT NULL,
            customer_name TEXT NULL,
            cashier_name TEXT NOT NULL,
            total INTEGER NOT NULL,
            lines_json TEXT NOT NULL,
            status INTEGER NOT NULL DEFAULT 0,
            error TEXT NULL,
            transaction_id TEXT NULL,
            stock_conflict INTEGER NOT NULL DEFAULT 0 CHECK (stock_conflict IN (0, 1)),
            cancel_reason TEXT NULL
          )''');
        raw.execute('''
          CREATE TABLE draft_carts (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            number INTEGER NOT NULL,
            customer_id TEXT NULL,
            customer_name TEXT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL,
            status INTEGER NOT NULL DEFAULT 0,
            charge_json TEXT NULL,
            paid_sale_ref TEXT NULL
          )''');
        raw.execute('''
          CREATE TABLE cached_customers (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            phone TEXT NOT NULL DEFAULT '',
            address TEXT NOT NULL DEFAULT '',
            outstanding_debt INTEGER NOT NULL DEFAULT 0
          )''');
        raw.execute("INSERT INTO cached_customers (id, name, outstanding_debt) VALUES ('k1', 'Bu Sri', 5000)");
        raw.execute("INSERT INTO draft_carts (number, created_at, updated_at) VALUES (1, 1790000000, 1790000000)");
        raw.execute(
          "INSERT INTO sales (client_ref, receipt_number, created_at, method, cashier_name, total, lines_json) "
          "VALUES ('old', 'OFF-ABCD-1', 1790000000, 0, 'kasir', 7000, "
          '\'[{"product_id":"p1","name":"Indomie","qty":2,"unit_price":3500}]\')',
        );
        raw.execute('PRAGMA user_version = 1');
      },
    );
    final db = AppDatabase(executor);
    addTearDown(db.close);

    final old = await (db.select(db.sales)..where((s) => s.clientRef.equals('old'))).getSingle();
    expect(old.total, 7000);
    expect(old.amountPaid, isNull);
    expect(old.changeJson, isNull);
    expect([old.kind, old.debtId], [0, isNull]);
    expect((await db.select(db.draftCarts).getSingle()).kind, 0);
    expect(await db.select(db.cachedDebts).get(), isEmpty);
    // The customer cache lost its debt total column but kept the customer.
    expect((await db.select(db.cachedCustomers).getSingle()).name, 'Bu Sri');

    await (db.update(db.sales)..where((s) => s.clientRef.equals('old'))).write(
      const SalesCompanion(amountPaid: Value(10000), changeJson: Value('[{"kind":"tunai","amount":3000}]')),
    );
    final log = DriftSalesLog(db, MemoryStore());
    final sale = (await log.byRef('old'))!;
    expect(sale.amountPaid, 10000);
    expect(sale.change.single.amount, 3000);
    expect(sale.lines.single.name, 'Indomie');
  });

  test('a v3 database loses the debt_total column and keeps its sales', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
      raw.execute('''
        CREATE TABLE sales (
          client_ref TEXT NOT NULL PRIMARY KEY, receipt_number TEXT NOT NULL, created_at INTEGER NOT NULL,
          method INTEGER NOT NULL, customer_id TEXT NULL, customer_name TEXT NULL, cashier_name TEXT NOT NULL,
          total INTEGER NOT NULL, lines_json TEXT NOT NULL, status INTEGER NOT NULL DEFAULT 0, error TEXT NULL,
          transaction_id TEXT NULL, stock_conflict INTEGER NOT NULL DEFAULT 0 CHECK (stock_conflict IN (0, 1)),
          cancel_reason TEXT NULL, amount_paid INTEGER NULL, change_json TEXT NULL,
          kind INTEGER NOT NULL DEFAULT 0, debt_id TEXT NULL, debt_total INTEGER NULL,
          debt_before INTEGER NULL, debt_after INTEGER NULL
        )''');
      raw.execute(
        "INSERT INTO sales (client_ref, receipt_number, created_at, method, cashier_name, total, lines_json, kind, debt_total, debt_before, debt_after) "
        "VALUES ('p', 'HTG-1', 1790000000, 0, 'kasir', 3000, '[]', 1, 9000, 5000, 2000)",
      );
      raw.execute('PRAGMA user_version = 3');
    }));
    addTearDown(db.close);
    final sale = (await DriftSalesLog(db, MemoryStore()).byRef('p'))!;
    expect((sale.total, sale.debtBefore, sale.debtAfter), (3000, 5000, 2000));
    final columns = await db.customSelect('PRAGMA table_info(sales)').get();
    expect(columns.map((c) => c.read<String>('name')), isNot(contains('debt_total')));
  });

  test('a change line of a kind this build does not know is skipped, not fatal', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.into(db.sales).insert(
          SalesCompanion.insert(
            clientRef: 'r',
            receiptNumber: 'OFF-1',
            createdAt: DateTime(2026, 11, 3),
            method: 0,
            cashierName: 'kasir',
            total: 7000,
            linesJson: '[]',
            amountPaid: const Value(10000),
            changeJson: const Value('[{"kind":"voucher","amount":1000},{"kind":"tunai","amount":2000}]'),
          ),
        );
    final sale = (await DriftSalesLog(db, MemoryStore()).byRef('r'))!;
    expect(sale.change.map((c) => c.kind), [ChangeKind.cash]);
  });
}
