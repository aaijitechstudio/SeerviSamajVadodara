/// Input sanitization utility for preventing XSS and injection attacks
/// Provides methods to sanitize user input before storing or displaying
class InputSanitizer {
  /// Sanitizes a string by removing potentially dangerous characters
  /// Removes HTML tags, script tags, and other dangerous patterns
  static String sanitizeString(String input) {
    if (input.isEmpty) return input;

    // Remove HTML tags
    String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove script tags and their content
    sanitized = sanitized.replaceAll(RegExp(r'<script[^>]*>.*?</script>', multiLine: true, caseSensitive: false), '');

    // Remove javascript: protocol
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');

    // Remove data: protocol (can be used for XSS)
    sanitized = sanitized.replaceAll(RegExp(r'data:', caseSensitive: false), '');

    // Remove vbscript: protocol
    sanitized = sanitized.replaceAll(RegExp(r'vbscript:', caseSensitive: false), '');

    // Remove on* event handlers (onclick, onerror, etc.)
    sanitized = sanitized.replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');

    // Trim whitespace
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Sanitizes text for display (removes dangerous HTML but preserves formatting)
  static String sanitizeForDisplay(String input) {
    if (input.isEmpty) return input;

    // Remove script tags
    String sanitized = input.replaceAll(RegExp(r'<script[^>]*>.*?</script>', multiLine: true, caseSensitive: false), '');

    // Remove dangerous event handlers
    sanitized = sanitized.replaceAll(RegExp(r'on\w+\s*="[^"]*"', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r"on\w+\s*='[^']*'", caseSensitive: false), '');

    // Remove javascript: and data: protocols
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'data:', caseSensitive: false), '');

    return sanitized;
  }

  /// Sanitizes a phone number (keeps only digits and +)
  static String sanitizePhone(String phone) {
    if (phone.isEmpty) return phone;

    // Keep only digits, spaces, hyphens, parentheses, and +
    return phone.replaceAll(RegExp(r'[^\d\s\-\(\)\+]'), '');
  }

  /// Sanitizes an email address (basic validation and sanitization)
  static String sanitizeEmail(String email) {
    if (email.isEmpty) return email;

    // Trim and convert to lowercase
    String sanitized = email.trim().toLowerCase();

    // Remove any HTML tags
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove dangerous characters (but keep @ and .)
    sanitized = sanitized.replaceAll(RegExp(r'[<>"]'), '');
    sanitized = sanitized.replaceAll(RegExp(r"'"), '');

    return sanitized;
  }

  /// Sanitizes a URL (removes dangerous protocols)
  static String sanitizeUrl(String url) {
    if (url.isEmpty) return url;

    String sanitized = url.trim();

    // Remove dangerous protocols
    final dangerousProtocols = ['javascript:', 'data:', 'vbscript:', 'file:', 'about:'];
    for (final protocol in dangerousProtocols) {
      if (sanitized.toLowerCase().startsWith(protocol)) {
        sanitized = sanitized.substring(protocol.length);
      }
    }

    // Ensure it starts with http:// or https:// if it looks like a URL
    if (sanitized.contains('.') && !sanitized.startsWith('http://') && !sanitized.startsWith('https://')) {
      sanitized = 'https://$sanitized';
    }

    return sanitized;
  }

  /// Sanitizes a name (removes special characters, keeps letters, spaces, hyphens, apostrophes)
  static String sanitizeName(String name) {
    if (name.isEmpty) return name;

    // Keep only letters, spaces, hyphens, apostrophes, and common name characters
    String sanitized = name.replaceAll(RegExp(r"[^a-zA-Z\s\-'.]"), '');

    // Remove multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    // Trim
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Sanitizes an address (removes dangerous characters but keeps address format)
  static String sanitizeAddress(String address) {
    if (address.isEmpty) return address;

    // Remove HTML tags
    String sanitized = address.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove script tags
    sanitized = sanitized.replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true), '');

    // Remove dangerous protocols
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'data:', caseSensitive: false), '');

    // Remove multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    // Trim
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Sanitizes text content (for posts, comments, etc.)
  static String sanitizeTextContent(String content) {
    if (content.isEmpty) return content;

    // Remove script tags
    String sanitized = content.replaceAll(RegExp(r'<script[^>]*>.*?</script>', multiLine: true, caseSensitive: false), '');

    // Remove dangerous event handlers
    sanitized = sanitized.replaceAll(RegExp(r'on\w+\s*="[^"]*"', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r"on\w+\s*='[^']*'", caseSensitive: false), '');

    // Remove javascript: and data: protocols
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'data:', caseSensitive: false), '');

    // Remove iframe tags (can be used for XSS)
    sanitized = sanitized.replaceAll(RegExp(r'<iframe[^>]*>.*?</iframe>', multiLine: true, caseSensitive: false), '');

    // Remove object and embed tags
    sanitized = sanitized.replaceAll(RegExp(r'<object[^>]*>.*?</object>', multiLine: true, caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'<embed[^>]*>', caseSensitive: false), '');

    return sanitized;
  }

  /// Validates and sanitizes a number (removes non-numeric characters)
  static String? sanitizeNumber(String input) {
    if (input.isEmpty) return null;

    // Remove all non-numeric characters except decimal point and minus sign
    String sanitized = input.replaceAll(RegExp(r'[^\d\.\-]'), '');

    // Remove multiple decimal points
    final parts = sanitized.split('.');
    if (parts.length > 2) {
      sanitized = '${parts[0]}.${parts.sublist(1).join()}';
    }

    return sanitized.isEmpty ? null : sanitized;
  }

  /// Escapes special characters for safe display
  static String escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Truncates string to max length and adds ellipsis if needed
  static String truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return '${input.substring(0, maxLength)}...';
  }

  /// Removes leading/trailing whitespace and normalizes internal whitespace
  static String normalizeWhitespace(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Validates if string contains only safe characters
  static bool isSafeString(String input) {
    // Check for dangerous patterns
    final dangerousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'data:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
    ];

    for (final pattern in dangerousPatterns) {
      if (pattern.hasMatch(input)) {
        return false;
      }
    }

    return true;
  }
}

