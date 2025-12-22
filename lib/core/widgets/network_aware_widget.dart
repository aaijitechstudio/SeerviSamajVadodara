import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connectivity_provider.dart';
import '../utils/network_helper.dart';

/// Network-aware widget that shows connectivity status
class NetworkAwareWidget extends ConsumerWidget {
  final Widget child;
  final bool showBanner;
  final Color? bannerColor;
  final TextStyle? bannerTextStyle;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.showBanner = true,
    this.bannerColor,
    this.bannerTextStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);

    return connectivityAsync.when(
      data: (connectivity) {
        if (!connectivity.isConnected && showBanner) {
          return Stack(
            children: [
              child,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildNetworkBanner(context, connectivity),
              ),
            ],
          );
        }
        return child;
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }

  Widget _buildNetworkBanner(
      BuildContext context, ConnectivityState connectivity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bannerColor ?? Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'No Internet Connection',
            style: bannerTextStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

/// Show network error snackbar
void showNetworkErrorSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No internet connection. Please check your network and try again.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}

/// Show network success snackbar
void showNetworkSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Network error dialog
Future<void> showNetworkErrorDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.red),
          SizedBox(width: 8),
          Text('No Internet Connection'),
        ],
      ),
      content: const Text(
        'Please check your internet connection and try again. Some features may not be available without internet.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
