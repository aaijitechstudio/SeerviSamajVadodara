import 'package:shared_preferences/shared_preferences.dart';

/// Authentication preferences utility
/// Handles "Remember Me" functionality and login state persistence
class AuthPreferences {
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _loginHistoryKey = 'login_history';

  /// Save "Remember Me" preference
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  /// Get "Remember Me" preference
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Save email for "Remember Me"
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedEmailKey, email);
  }

  /// Get saved email
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey);
  }

  /// Clear saved email
  static Future<void> clearSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
  }

  /// Add login activity to history
  static Future<void> addLoginActivity({
    required String email,
    required DateTime timestamp,
    required String method, // 'email', 'google', 'phone'
    String? deviceInfo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getLoginHistory();

    final activity = {
      'email': email,
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'deviceInfo': deviceInfo ?? 'Unknown',
    };

    // Add to beginning of list
    history.insert(0, activity);

    // Keep only last 20 login activities
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }

    // Save as JSON string
    final historyJson = history.map((e) => e.toString()).join('|||');
    await prefs.setString(_loginHistoryKey, historyJson);
  }

  /// Get login history
  static Future<List<Map<String, dynamic>>> getLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_loginHistoryKey);

    if (historyJson == null || historyJson.isEmpty) {
      return [];
    }

    try {
      // Simple parsing (for production, use proper JSON)
      final activities = <Map<String, dynamic>>[];
      final parts = historyJson.split('|||');

      for (final part in parts) {
        if (part.isNotEmpty) {
          // Parse simple map format
          // Format: {email: value, timestamp: value, method: value, deviceInfo: value}
          final map = <String, dynamic>{};
          final regex = RegExp(r'(\w+):\s*([^,}]+)');
          final matches = regex.allMatches(part);

          for (final match in matches) {
            final key = match.group(1)?.trim();
            final value = match.group(2)?.trim();
            if (key != null && value != null) {
              map[key] = value;
            }
          }

          if (map.isNotEmpty) {
            activities.add(map);
          }
        }
      }

      return activities;
    } catch (e) {
      return [];
    }
  }

  /// Clear login history
  static Future<void> clearLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginHistoryKey);
  }

  /// Clear all auth preferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_loginHistoryKey);
  }
}

