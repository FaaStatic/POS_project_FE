import 'package:integration_test/integration_test.dart';

import '../test/app/app_flow_test.dart' as flows;

/// Runs the app flows (login → offline sale → sync, parallel tabs) on a real
/// device or emulator: `flutter test integration_test`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  flows.main();
}
