import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mmkv/mmkv.dart';
import 'package:workmanager/workmanager.dart';

import 'features/sync/data/sync_scheduler.dart';
import 'features/sync/domain/usecases/sync_usecases.dart';

/// Set by bootstrap so the background isolate loads the same .env as the app.
const envFileKey = 'env_file';

/// Workmanager entry point (separate isolate/engine). Builds only what the
/// 12:00/00:00 sync needs, sends the queue, and schedules the next slot.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task != SyncScheduler.taskName) return true;
    WidgetsFlutterBinding.ensureInitialized();
    await MMKV.initialize();
    final store = MmkvStore();
    final env = DotEnv();
    await env.load(fileName: store.getString(envFileKey) ?? '.env.prod');
    final db = AppDatabase();
    try {
      final config = AppConfig.fromEnv(env.env);
      final tokens = SecureTokenStore();
      final api = ApiClient.create(config);
      final bare = ApiClient.create(config);
      final auth = AuthRepositoryImpl(remote: AuthRemoteDatasource(api: api, bare: bare), tokens: tokens, usesCookie: false);
      if (await auth.restore() case Err()) return true;
      final cache = DriftCatalogCache(db);
      final sync = SyncPendingTransactions(
        DriftSalesLog(db, store),
        TransactionRepositoryImpl(TransactionRemoteDatasource(api)),
        RefreshCatalog(
          ProductRepositoryImpl(ProductRemoteDatasource(api)),
          CategoryRepositoryImpl(CategoryRemoteDatasource(api)),
          CustomerRepositoryImpl(CustomerRemoteDatasource(api)),
          cache,
        ),
      );
      await sync();
      return true;
    } finally {
      await db.close();
      await const SyncScheduler().scheduleNext();
    }
  });
}
