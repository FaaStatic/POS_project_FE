import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';

/// Interface-level connectivity. A connected Wi-Fi without internet still counts
/// as online; checkout then falls back to the queue when the request cannot connect.
class ConnectivityNetworkStatus implements NetworkStatus {
  ConnectivityNetworkStatus([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  static bool _online(List<ConnectivityResult> results) => results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async => _online(await _connectivity.checkConnectivity());

  @override
  Stream<bool> watch() => _connectivity.onConnectivityChanged.map(_online).distinct();
}
