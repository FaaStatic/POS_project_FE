import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CachedProducts, CachedCategories, CachedCustomers, Sales, DraftCarts, DraftCartItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'kasir'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v2: cash received and change lines on sales.
          if (from < 2) {
            await m.addColumn(sales, sales.amountPaid);
            await m.addColumn(sales, sales.changeJson);
          }
        },
        beforeOpen: (details) async => customStatement('PRAGMA foreign_keys = ON'),
      );
}
