import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'app_logger.dart';

/// Network helper utility class
/// Provides methods to check network connectivity before making API calls
class NetworkHelper {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device has network connectivity
  /// Returns true if any network interface is available (WiFi, Mobile, Ethernet)
  static Future<bool> hasNetworkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } catch (e) {
      AppLogger.error('Error checking network connectivity: $e');
      return false;
    }
  }

  /// Check if device has actual internet connectivity
  /// This performs a real HTTP request to verify internet access
  static Future<bool> hasInternetConnectivity({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      // First check if network interface is available
      final hasNetwork = await hasNetworkConnectivity();
      if (!hasNetwork) {
        return false;
      }

      // Try to reach a reliable server to verify internet connectivity
      // Using Google's DNS and a lightweight endpoint
      final response = await http
          .get(
            Uri.parse('https://www.google.com'),
          )
          .timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.debug('No internet connectivity: $e');
      return false;
    }
  }

  /// Get current connectivity result
  static Future<ConnectivityResult> getConnectivityResult() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _mapConnectivityResult(result);
    } catch (e) {
      AppLogger.error('Error getting connectivity result: $e');
      return ConnectivityResult.none;
    }
  }

  /// Map ConnectivityResult list to single result
  static ConnectivityResult _mapConnectivityResult(
      List<ConnectivityResult> results) {
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

  /// Get user-friendly connectivity message
  static String getConnectivityMessage(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected via WiFi';
      case ConnectivityResult.mobile:
        return 'Connected via Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected via Ethernet';
      case ConnectivityResult.none:
        return 'No Internet Connection';
      case ConnectivityResult.bluetooth:
        return 'Connected via Bluetooth';
      case ConnectivityResult.vpn:
        return 'Connected via VPN';
      case ConnectivityResult.other:
        return 'Network Connection Available';
    }
  }

  /// Check network before making API call
  /// Throws NetworkException if no connectivity
  static Future<void> ensureNetworkConnectivity() async {
    final hasNetwork = await hasNetworkConnectivity();
    if (!hasNetwork) {
      throw NetworkException('No internet connection available');
    }
  }

  /// Check network before making API call (lightweight check)
  /// Only checks network interface, not actual internet
  /// Throws NetworkException if no network interface
  static Future<void> ensureNetworkInterface() async {
    final hasNetwork = await hasNetworkConnectivity();
    if (!hasNetwork) {
      throw NetworkException('No network connection available');
    }
  }
}

/// Network exception class
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}
