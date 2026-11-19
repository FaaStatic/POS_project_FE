import 'bootstrap.dart';
import 'firebase_options_prod.dart';

void main() => bootstrap('.env.prod', DefaultFirebaseOptions.currentPlatform);
