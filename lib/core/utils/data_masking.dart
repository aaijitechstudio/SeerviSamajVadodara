/// Data masking utility for protecting sensitive information in UI
/// Provides methods to mask phone numbers, emails, and other sensitive data
class DataMasking {
  /// Masks a phone number, showing only last 4 digits
  /// Example: "9876543210" -> "***-***-3210"
  static String maskPhone(String phone) {
    if (phone.isEmpty) return phone;
    if (phone.length < 4) return '***';

    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length < 4) return '***';

    final last4 = cleaned.substring(cleaned.length - 4);
    return '***-***-$last4';
  }

  /// Masks a phone number with country code
  /// Example: "+919876543210" -> "+91 ***-***-3210"
  static String maskPhoneWithCountryCode(String phone) {
    if (phone.isEmpty) return phone;

    // Extract country code if present
    final countryCodeMatch = RegExp(r'^\+?(\d{1,3})').firstMatch(phone);
    if (countryCodeMatch != null) {
      final countryCode = countryCodeMatch.group(1)!;
      final number = phone.substring(countryCodeMatch.end);
      return '+$countryCode ${maskPhone(number)}';
    }

    return maskPhone(phone);
  }

  /// Masks an email address, showing only first 2 characters and domain
  /// Example: "john.doe@example.com" -> "jo***@example.com"
  static String maskEmail(String email) {
    if (email.isEmpty) return email;

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '***@$domain';
    }

    final visibleChars = name.length > 5 ? 3 : 2;
    final visible = name.substring(0, visibleChars);
    return '$visible***@$domain';
  }

  /// Masks an email address completely, showing only domain
  /// Example: "john.doe@example.com" -> "***@example.com"
  static String maskEmailCompletely(String email) {
    if (email.isEmpty) return email;

    final parts = email.split('@');
    if (parts.length != 2) return email;

    return '***@${parts[1]}';
  }

  /// Masks a name, showing only first letter and last letter
  /// Example: "John Doe" -> "J***e"
  static String maskName(String name) {
    if (name.isEmpty) return name;
    if (name.length <= 2) return '***';

    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      // Single word
      final word = words[0];
      if (word.length <= 2) return '***';
      return '${word[0]}***${word[word.length - 1]}';
    } else {
      // Multiple words (e.g., "John Doe")
      final firstWord = words[0];
      final lastWord = words[words.length - 1];
      return '${firstWord[0]}***${lastWord[lastWord.length - 1]}';
    }
  }

  /// Masks an address, showing only first few characters
  /// Example: "123 Main Street, City" -> "123 M***"
  static String maskAddress(String address, {int visibleChars = 5}) {
    if (address.isEmpty) return address;
    if (address.length <= visibleChars) return address;

    final visible = address.substring(0, visibleChars);
    return '$visible***';
  }

  /// Masks a credit card number, showing only last 4 digits
  /// Example: "1234567890123456" -> "**** **** **** 3456"
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return cardNumber;

    final cleaned = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length < 4) return '****';

    final last4 = cleaned.substring(cleaned.length - 4);

    // Format as **** **** **** 3456
    if (cleaned.length == 16) {
      return '**** **** **** $last4';
    }

    return '****$last4';
  }

  /// Masks a string generically, showing only first and last characters
  /// Example: "sensitive_data" -> "s***a"
  static String maskString(String value, {int visibleStart = 1, int visibleEnd = 1}) {
    if (value.isEmpty) return value;
    if (value.length <= visibleStart + visibleEnd) return '***';

    final start = value.substring(0, visibleStart);
    final end = value.substring(value.length - visibleEnd);
    return '$start***$end';
  }

  /// Masks sensitive data in a map (for logging/debugging)
  /// Masks fields like 'phone', 'email', 'password', etc.
  static Map<String, dynamic> maskSensitiveFields(Map<String, dynamic> data) {
    final masked = Map<String, dynamic>.from(data);
    final sensitiveFields = ['phone', 'email', 'password', 'token', 'secret', 'apiKey'];

    for (final field in sensitiveFields) {
      if (masked.containsKey(field) && masked[field] is String) {
        final value = masked[field] as String;
        if (field == 'phone') {
          masked[field] = maskPhone(value);
        } else if (field == 'email') {
          masked[field] = maskEmail(value);
        } else {
          masked[field] = '***';
        }
      }
    }

    return masked;
  }

  /// Partially reveals a masked value (for verification purposes)
  /// Example: maskPhone("9876543210") -> "***-***-3210"
  /// This is useful for showing partial data when user needs to verify
  static String partiallyReveal(String value, {int revealChars = 4}) {
    if (value.isEmpty) return value;
    if (value.length <= revealChars) return value;

    final lastChars = value.substring(value.length - revealChars);
    final masked = '*' * (value.length - revealChars);
    return '$masked$lastChars';
  }
}

