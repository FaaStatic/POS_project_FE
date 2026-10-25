/// Connectivity as seen by the app. Implemented per platform in the apps.
abstract interface class NetworkStatus {
  Future<bool> isOnline();
  Stream<bool> watch();
}
