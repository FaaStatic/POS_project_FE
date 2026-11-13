import 'bootstrap.dart';
import 'firebase_options_staging.dart';

void main() =>
    bootstrap('.env.staging', DefaultFirebaseOptions.currentPlatform);
