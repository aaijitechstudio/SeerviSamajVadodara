import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';

/// Standardized error state widget for consistent error displays
class ErrorStateWidget extends StatelessWidget {
  final Object? error;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorStateWidget({
    super.key,
    this.error,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
  });

  String _getErrorMessage() {
    if (message != null) return message!;
    if (error != null) {
      final errorString = error.toString();
      // Clean up common error messages
      if (errorString.contains('API key')) {
        return 'API key not configured';
      }
      if (errorString.contains('network') || errorString.contains('connection')) {
        return 'Network connection failed';
      }
      if (errorString.contains('timeout')) {
        return 'Request timed out';
      }
      return 'Something went wrong';
    }
    return 'An error occurred';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: DesignTokens.iconSizeXL * 2,
              color: AppColors.errorColor,
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              title ?? 'Error',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightSemiBold,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingM),
            Text(
              _getErrorMessage(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: DesignTokens.spacingXL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.textOnPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

/// API error widget
class ApiErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const ApiErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'API Error',
      message: message ?? 'Failed to load data from server',
      onRetry: onRetry,
      icon: Icons.cloud_off,
    );
  }
}

