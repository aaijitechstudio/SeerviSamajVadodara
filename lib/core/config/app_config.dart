import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_logger.dart';

/// Application configuration manager
/// Loads and provides access to environment variables
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// Initialize the configuration by loading .env file
  /// Should be called in main() before runApp()
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env file doesn't exist, continue with default values
      // This allows the app to run in development without .env
      AppLogger.warning('.env file not found. Using default values.');
    }
  }

  /// Get NewsData.io API key from environment
  /// Returns the API key or a default value if not set
  static String get newsDataApiKey {
    return dotenv.env['NEWSDATA_API_KEY'] ?? '';
  }

  /// Check if NewsData.io API key is configured
  static bool get isNewsDataApiKeyConfigured {
    final key = newsDataApiKey;
    return key.isNotEmpty && key != 'your_api_key_here';
  }

  /// Get any environment variable by key
  /// Returns null if key doesn't exist
  static String? getEnv(String key) {
    return dotenv.env[key];
  }

  /// Get environment variable with default value
  static String getEnvWithDefault(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }
}
