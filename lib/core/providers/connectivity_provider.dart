import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Network connectivity state
class ConnectivityState {
  final ConnectivityResult result;
  final bool isConnected;
  final bool hasInternet;

  const ConnectivityState({
    required this.result,
    required this.isConnected,
    required this.hasInternet,
  });

  ConnectivityState copyWith({
    ConnectivityResult? result,
    bool? isConnected,
    bool? hasInternet,
  }) {
    return ConnectivityState(
      result: result ?? this.result,
      isConnected: isConnected ?? this.isConnected,
      hasInternet: hasInternet ?? this.hasInternet,
    );
  }
}

/// Connectivity service provider
final connectivityServiceProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Network connectivity stream provider
/// Monitors network connectivity changes in real-time
final connectivityStreamProvider = StreamProvider<ConnectivityState>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);

  return connectivity.onConnectivityChanged.map((result) {
    final connectivityResult = _mapConnectivityResult(result);
    final isConnected = connectivityResult != ConnectivityResult.none;

    return ConnectivityState(
      result: connectivityResult,
      isConnected: isConnected,
      hasInternet: isConnected, // Will be updated by checkInternetConnectivity
    );
  });
});

/// Current network connectivity provider
final connectivityProvider = StreamProvider<ConnectivityState>((ref) async* {
  final connectivity = ref.watch(connectivityServiceProvider);

  // Get initial connectivity status
  final initialResult = await connectivity.checkConnectivity();
  final initialConnectivityResult = _mapConnectivityResult(initialResult);
  final initialIsConnected =
      initialConnectivityResult != ConnectivityResult.none;

  yield ConnectivityState(
    result: initialConnectivityResult,
    isConnected: initialIsConnected,
    hasInternet: initialIsConnected,
  );

  // Listen to connectivity changes
  yield* connectivity.onConnectivityChanged.map((result) {
    final connectivityResult = _mapConnectivityResult(result);
    final isConnected = connectivityResult != ConnectivityResult.none;

    return ConnectivityState(
      result: connectivityResult,
      isConnected: isConnected,
      hasInternet: isConnected,
    );
  });
});

/// Helper to check if device has internet connection
/// This provider checks actual internet connectivity, not just network interface
final hasInternetProvider = FutureProvider<bool>((ref) async {
  final connectivity = ref.watch(connectivityServiceProvider);
  final result = await connectivity.checkConnectivity();

  // If no network interface, definitely no internet
  if (result.contains(ConnectivityResult.none)) {
    return false;
  }

  // For other cases, we assume internet is available
  // Actual internet connectivity will be verified when making API calls
  return true;
});

/// Helper function to map ConnectivityResult list to single result
ConnectivityResult _mapConnectivityResult(List<ConnectivityResult> results) {
  if (results.isEmpty || results.contains(ConnectivityResult.none)) {
    return ConnectivityResult.none;
  }

  // Prefer WiFi, then mobile, then ethernet, then bluetooth, then vpn
  if (results.contains(ConnectivityResult.wifi)) {
    return ConnectivityResult.wifi;
  }
  if (results.contains(ConnectivityResult.mobile)) {
    return ConnectivityResult.mobile;
  }
  if (results.contains(ConnectivityResult.ethernet)) {
    return ConnectivityResult.ethernet;
  }
  if (results.contains(ConnectivityResult.bluetooth)) {
    return ConnectivityResult.bluetooth;
  }
  if (results.contains(ConnectivityResult.vpn)) {
    return ConnectivityResult.vpn;
  }

  return ConnectivityResult.other;
}

/// Helper function to get connectivity result as string
String getConnectivityResultString(ConnectivityResult result) {
  switch (result) {
    case ConnectivityResult.wifi:
      return 'WiFi';
    case ConnectivityResult.mobile:
      return 'Mobile Data';
    case ConnectivityResult.ethernet:
      return 'Ethernet';
    case ConnectivityResult.none:
      return 'No Connection';
    case ConnectivityResult.bluetooth:
      return 'Bluetooth';
    case ConnectivityResult.vpn:
      return 'VPN';
    case ConnectivityResult.other:
      return 'Other';
  }
}
