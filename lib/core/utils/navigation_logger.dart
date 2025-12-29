import 'package:flutter/material.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'app_logger.dart';

/// Navigation observer that logs all route changes
class NavigationLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logNavigation('REMOVE', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && oldRoute != null) {
      _logNavigation('REPLACE', newRoute, oldRoute);
    }
  }

  void _logNavigation(String action, Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? route.runtimeType.toString();
    final previousRouteName = previousRoute?.settings.name ?? previousRoute?.runtimeType.toString() ?? 'None';
    final arguments = route.settings.arguments?.toString() ?? 'None';

    // Format detailed log message
    final logMessage = 'Navigation [$action] -> Route: $routeName | From: $previousRouteName | Args: $arguments';

    AppLogger.info(logMessage);

    // Also print to console for terminal visibility
    print('📱 [NAVIGATION] $action: $routeName (from: $previousRouteName)');
  }
}

/// Logs app information on startup
class AppInfoLogger {
  static Future<void> logAppInfo() async {
    try {
      // Get package info
      final packageInfo = await PackageInfo.fromPlatform();

      // Get device platform
      final platform = Platform.operatingSystem;
      final platformVersion = Platform.operatingSystemVersion;

      // Format detailed log message
      final logMessage = 'App Started | Name: ${packageInfo.appName} | '
          'Version: ${packageInfo.version} | Build: ${packageInfo.buildNumber} | '
          'Package: ${packageInfo.packageName} | Platform: $platform';

      AppLogger.info(logMessage);

      // Print to console for terminal visibility
      print('═══════════════════════════════════════════════════════════');
      print('🚀 APP STARTED');
      print('═══════════════════════════════════════════════════════════');
      print('📱 App Name: ${packageInfo.appName}');
      print('📦 Version: ${packageInfo.version} (Build: ${packageInfo.buildNumber})');
      print('📋 Package: ${packageInfo.packageName}');
      print('💻 Platform: $platform ($platformVersion)');
      print('═══════════════════════════════════════════════════════════');
    } catch (e) {
      AppLogger.error('Failed to log app info', e);
      print('⚠️  Failed to log app info: $e');
    }
  }
}

