import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Test helper utilities for common testing scenarios
class TestHelpers {
  /// Create a ProviderContainer for testing
  /// Useful for testing providers in isolation
  static ProviderContainer createContainer({
    List<Override>? overrides,
  }) {
    return ProviderContainer(
      overrides: overrides ?? [],
    );
  }

  /// Dispose of a ProviderContainer after test
  static void disposeContainer(ProviderContainer container) {
    container.dispose();
  }

  /// Wait for a specified duration (useful for async testing)
  static Future<void> waitFor(Duration duration) {
    return Future.delayed(duration);
  }

  /// Create a mock date for testing
  static DateTime createMockDate({
    int year = 2024,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
  }) {
    return DateTime(year, month, day, hour, minute);
  }
}

/// Custom matchers for common assertions
class CustomMatchers {
  /// Matcher for checking if a string is a valid email
  static Matcher isValidEmail = predicate<String>(
    (email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email),
    'is a valid email',
  );

  /// Matcher for checking if a string is a valid phone number
  static Matcher isValidPhone = predicate<String>(
    (phone) => RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(phone),
    'is a valid phone number',
  );
}
