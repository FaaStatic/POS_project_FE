import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CachedProducts, CachedCategories, CachedCustomers, CachedDebts, Sales, DraftCarts, DraftCartItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'kasir'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v2: cash received and change lines on sales.
          if (from < 2) {
            await m.addColumn(sales, sales.amountPaid);
            await m.addColumn(sales, sales.changeJson);
          }
          // v3: debt payments share the sales log; open debts are cached.
          if (from < 3) {
            await m.addColumn(sales, sales.kind);
            await m.addColumn(sales, sales.debtId);
            await m.addColumn(sales, sales.debtBefore);
            await m.addColumn(sales, sales.debtAfter);
            await m.addColumn(draftCarts, draftCarts.kind);
            await m.createTable(cachedDebts);
            // The customer cache no longer keeps a debt total; open debts have their own table.
            await m.alterTable(TableMigration(cachedCustomers));
          }
          // v4: sales no longer keep the debt's original total; the table is rebuilt without that column.
          if (from < 4) await m.alterTable(TableMigration(sales));
        },
        beforeOpen: (details) async => customStatement('PRAGMA foreign_keys = ON'),
      );
}
