/// Password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}

/// Password validation and strength checking utility
/// Provides password strength validation and feedback
class PasswordValidator {
  /// Minimum password length (can be increased for stronger security)
  static const int minLength = 8;

  /// Maximum password length
  static const int maxLength = 128;

  /// Validates password against security requirements
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String password, {bool strict = false}) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }

    if (password.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    if (password.length > maxLength) {
      return 'Password must be less than $maxLength characters';
    }

    if (strict) {
      // Strict validation with complexity requirements
      if (!_hasUppercase(password)) {
        return 'Password must contain at least one uppercase letter';
      }

      if (!_hasLowercase(password)) {
        return 'Password must contain at least one lowercase letter';
      }

      if (!_hasNumber(password)) {
        return 'Password must contain at least one number';
      }

      if (!_hasSpecialChar(password)) {
        return 'Password must contain at least one special character (!@#\$%^&*)';
      }
    }

    // Check against common weak passwords
    if (_isCommonPassword(password)) {
      return 'This password is too common. Please choose a stronger password';
    }

    return null; // Valid password
  }

  /// Calculates password strength
  static PasswordStrength calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length score
    if (password.length >= minLength) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    // Character variety score
    if (_hasUppercase(password)) score += 1;
    if (_hasLowercase(password)) score += 1;
    if (_hasNumber(password)) score += 1;
    if (_hasSpecialChar(password)) score += 1;

    // Bonus for mixed case and numbers
    if (_hasUppercase(password) && _hasLowercase(password)) score += 1;
    if (_hasNumber(password) && _hasSpecialChar(password)) score += 1;

    // Penalty for common patterns
    if (_isCommonPassword(password)) score -= 2;
    if (_hasRepeatingChars(password)) score -= 1;
    if (_hasSequentialChars(password)) score -= 1;

    // Determine strength level
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 6) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Gets user-friendly strength description
  static String getStrengthDescription(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  /// Gets strength color (for UI)
  static int getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0xFFFF5252; // Red
      case PasswordStrength.medium:
        return 0xFFFF9800; // Orange
      case PasswordStrength.strong:
        return 0xFFFFC107; // Amber
      case PasswordStrength.veryStrong:
        return 0xFF4CAF50; // Green
    }
  }

  /// Gets strength percentage (0-100)
  static double getStrengthPercentage(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.50;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  /// Gets suggestions for improving password strength
  static List<String> getSuggestions(String password) {
    final suggestions = <String>[];

    if (password.length < minLength) {
      suggestions.add('Use at least $minLength characters');
    }

    if (!_hasUppercase(password)) {
      suggestions.add('Add uppercase letters');
    }

    if (!_hasLowercase(password)) {
      suggestions.add('Add lowercase letters');
    }

    if (!_hasNumber(password)) {
      suggestions.add('Add numbers');
    }

    if (!_hasSpecialChar(password)) {
      suggestions.add('Add special characters (!@#\$%^&*)');
    }

    if (_isCommonPassword(password)) {
      suggestions.add('Avoid common passwords');
    }

    if (_hasRepeatingChars(password)) {
      suggestions.add('Avoid repeating characters');
    }

    if (_hasSequentialChars(password)) {
      suggestions.add('Avoid sequential characters (123, abc)');
    }

    return suggestions;
  }

  // Helper methods
  static bool _hasUppercase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool _hasLowercase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool _hasNumber(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool _hasSpecialChar(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool _isCommonPassword(String password) {
    final commonPasswords = [
      'password',
      '12345678',
      '123456789',
      '1234567890',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      '1234567',
      'sunshine',
      'princess',
      'football',
      'iloveyou',
    ];
    return commonPasswords.contains(password.toLowerCase());
  }

  static bool _hasRepeatingChars(String password) {
    // Check for 3 or more repeating characters
    return RegExp(r'(.)\1{2,}').hasMatch(password);
  }

  static bool _hasSequentialChars(String password) {
    // Check for sequential patterns like "123", "abc", "321", "cba"
    final lower = password.toLowerCase();
    for (int i = 0; i < lower.length - 2; i++) {
      final char1 = lower.codeUnitAt(i);
      final char2 = lower.codeUnitAt(i + 1);
      final char3 = lower.codeUnitAt(i + 2);

      // Check forward sequence
      if (char2 == char1 + 1 && char3 == char2 + 1) {
        return true;
      }
      // Check backward sequence
      if (char2 == char1 - 1 && char3 == char2 - 1) {
        return true;
      }
    }
    return false;
  }
}

