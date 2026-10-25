import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/di.dart';

Future<void> bootstrap(String envFile) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: envFile);
  await initializeDateFormatting();
  setupDependencies(config: AppConfig.fromEnv(dotenv.env), store: await PrefsStore.create());
  runApp(const CmsApp());
}
