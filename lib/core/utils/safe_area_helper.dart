// lib/core/utils/safe_area_helper.dart
// VERSION: 1.0 PRODUCTION READY
// AUTHORITY: Android Navigation Bar Fix - Comprehensive Solution
// PURPOSE: Provides utilities for handling safe area insets, especially for Android navigation bars

import 'package:flutter/material.dart';

/// Helper class for safe area calculations.
///
/// Provides utilities to handle:
/// - System navigation bars (Android 3-button navigation)
/// - Keyboard insets
/// - Status bar insets
/// - Combined safe area calculations
///
/// Code Deviation: Created comprehensive safe area helper (2025-01-16)
/// Reason: Android devices with navigation buttons cause UI to go under system bars
/// Fix: Provides consistent way to calculate safe bottom padding across entire app
class SafeAreaHelper {
  /// Get safe bottom padding that accounts for both keyboard and navigation bars.
  ///
  /// This is the recommended way to add bottom padding to:
  /// - Bottom sheets
  /// - Modals
  /// - Fixed bottom elements
  /// - Any content that might be hidden by system UI
  ///
  /// Returns the maximum of:
  /// - Keyboard height (viewInsets.bottom)
  /// - System navigation bar height (padding.bottom)
  ///
  /// Example:
  /// ```dart
  /// padding: EdgeInsets.only(
  ///   bottom: SafeAreaHelper.getSafeBottomPadding(context),
  /// )
  /// ```
  static double getSafeBottomPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Use the maximum of keyboard height and system navigation bar height
    return mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom
        : mediaQuery.padding.bottom;
  }

  /// Get safe bottom padding with additional spacing.
  ///
  /// Useful when you need extra spacing beyond the safe area.
  static double getSafeBottomPaddingWithSpacing(
    BuildContext context,
    double additionalSpacing,
  ) {
    return getSafeBottomPadding(context) + additionalSpacing;
  }

  /// Get only system navigation bar height (ignores keyboard).
  ///
  /// Useful when keyboard is not shown but you still need navigation bar padding.
  static double getSystemNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get only keyboard height (ignores navigation bars).
  ///
  /// Useful when you only care about keyboard, not system bars.
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if device has system navigation bars (not gesture navigation).
  ///
  /// Returns true if padding.bottom > 0, indicating physical/software buttons.
  static bool hasSystemNavigationBar(BuildContext context) {
    return MediaQuery.of(context).padding.bottom > 0;
  }
}


