import 'package:flutter/foundation.dart';

/// Log levels for different types of logs
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Centralized logging utility
/// Follows international coding standards for logging
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  /// Log debug messages (only in debug mode)
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _log(LogLevel.debug, message, error, stackTrace);
    }
  }

  /// Log info messages
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _log(LogLevel.info, message, error, stackTrace);
    }
  }

  /// Log warning messages
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _log(LogLevel.warning, message, error, stackTrace);
    }
  }

  /// Log error messages
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Always log errors, even in release mode (but only message, not stack trace)
    if (kDebugMode) {
      _log(LogLevel.error, message, error, stackTrace);
    } else {
      // In release mode, only log error message without stack trace
      debugPrint('❌ ERROR: $message');
    }
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    final timestamp = DateTime.now().toIso8601String();
    final levelEmoji = _getLevelEmoji(level);
    final levelName = level.name.toUpperCase();

    // Format log message
    final logMessage = '[$timestamp] $levelEmoji $levelName: $message';

    // Use debugPrint for better performance in Flutter
    debugPrint(logMessage);

    // Log error details if provided
    if (error != null) {
      debugPrint('   Error: $error');
    }

    // Log stack trace only in debug mode and if provided
    if (kDebugMode && stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  /// Get emoji for log level
  static String _getLevelEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  /// Log Firebase initialization
  static void logFirebaseInit({required bool success, Object? error}) {
    if (success) {
      info('Firebase initialized successfully');
    } else {
      AppLogger.error('Firebase initialization failed', error);
      if (error != null) {
        warning('Please check Firebase configuration files');
      }
    }
  }

  /// Log API call
  static void logApiCall(String endpoint, {String? method}) {
    debug('API Call: ${method ?? 'GET'} $endpoint');
  }

  /// Log API response
  static void logApiResponse(String endpoint,
      {int? statusCode, Object? error}) {
    if (error != null) {
      AppLogger.error('API Error: $endpoint', error);
    } else if (statusCode != null) {
      if (statusCode >= 200 && statusCode < 300) {
        debug('API Success: $endpoint ($statusCode)');
      } else {
        warning('API Warning: $endpoint ($statusCode)');
      }
    }
  }

  /// Log user action
  static void logUserAction(String action) {
    debug('User Action: $action');
  }

  /// Log navigation
  static void logNavigation(String route) {
    debug('Navigation: $route');
  }
}
