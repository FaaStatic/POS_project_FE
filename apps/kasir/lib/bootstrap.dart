import 'package:core/core.dart';
import 'package:core/mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mmkv/mmkv.dart';
import 'package:workmanager/workmanager.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'background.dart';
import 'features/push/data/push_service.dart';
import 'firebase_options.dart';

Future<void> bootstrap(String envFile) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: envFile);
  await initializeDateFormatting();
  await MMKV.initialize();
  final store = MmkvStore();
  await store.setString(envFileKey, envFile);
  setupDependencies(config: AppConfig.fromEnv(dotenv.env), store: store);
  await getIt<PushService>().init(DefaultFirebaseOptions.currentPlatform);
  await Workmanager().initialize(callbackDispatcher);
  runApp(const KasirApp());
}
