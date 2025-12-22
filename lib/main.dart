import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/config/app_config.dart';
import 'core/utils/app_logger.dart';
import 'features/home/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await AppConfig.load();

  // Initialize Firebase - with robust error handling and retry logic
  // Firebase.initializeApp() will auto-detect config from google-services.json
  // and GoogleService-Info.plist files

  // Check if Firebase is already initialized
  bool firebaseInitialized = false;
  if (Firebase.apps.isNotEmpty) {
    AppLogger.info(
        'Firebase already initialized (${Firebase.apps.length} app(s))');
    firebaseInitialized = true;
  } else {
    // Verify config files exist before attempting initialization
    bool configFilesExist = _verifyFirebaseConfigFiles();
    if (!configFilesExist) {
      AppLogger.warning('Firebase config files may be missing. Please ensure:\n'
          '- android/app/google-services.json exists\n'
          '- ios/Runner/GoogleService-Info.plist exists\n'
          'Then run: flutter clean && flutter pub get && flutter run');
    }

    // Try to initialize Firebase with retry logic
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        AppLogger.info('Initializing Firebase... (Attempt $attempt/3)');

        // For iOS, ensure we wait a bit before initialization to let native side prepare
        if (Platform.isIOS && attempt == 1) {
          await Future.delayed(const Duration(milliseconds: 200));
        }

        // Use default initialization - it will auto-detect config files
        // Wrap in try-catch to handle any synchronous errors
        try {
          await Firebase.initializeApp();
        } catch (e) {
          // If initialization throws synchronously, wrap it
          if (e is FirebaseException) {
            rethrow;
          }
          throw FirebaseException(
            plugin: 'firebase_core',
            code: 'initialization-failed',
            message: 'Firebase initialization failed: $e',
          );
        }

        // Wait longer for Firebase to fully initialize internally
        // This is especially important for iOS
        await Future.delayed(const Duration(milliseconds: 300));

        // Verify initialization was successful by checking apps list
        if (Firebase.apps.isEmpty) {
          throw Exception(
              'Firebase.initializeApp() completed but no apps found');
        }

        // Additional verification: try to access the default app
        try {
          final app = Firebase.app();
          AppLogger.info('Firebase app verified: ${app.name}');
        } catch (e) {
          // If we can't access the app, it might not be fully ready
          AppLogger.warning('Firebase app exists but not yet accessible: $e');
          // Wait a bit more
          await Future.delayed(const Duration(milliseconds: 200));
        }

        // Simple verification - just check that apps list is not empty
        final appCount = Firebase.apps.length;
        AppLogger.info(
            'Firebase initialized successfully. Found $appCount app(s)');
        AppLogger.logFirebaseInit(success: true);
        firebaseInitialized = true;
        break; // Success, exit retry loop
      } on FirebaseException catch (e) {
        // Handle Firebase-specific errors
        AppLogger.error(
            'Firebase initialization attempt $attempt failed with FirebaseException',
            e,
            StackTrace.current);

        // Log the specific error code and message for debugging
        AppLogger.warning(
            'Firebase error code: ${e.code}, message: ${e.message}');

        // Check for specific error codes
        if (e.code == 'not-initialized' ||
            e.message?.contains('not been correctly initialized') == true) {
          AppLogger.warning('Firebase config files may not be processed. '
              'This usually requires a clean rebuild:\n'
              '1. Run: flutter clean\n'
              '2. Run: flutter pub get\n'
              '3. For iOS: cd ios && pod install && cd ..\n'
              '4. Run: flutter run');

          // For iOS, also suggest checking Xcode project settings
          if (Platform.isIOS) {
            AppLogger.warning(
                'For iOS, also ensure GoogleService-Info.plist is added to the Xcode project target.');
          }
        }

        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          final delaySeconds = attempt * 2; // Longer delay for iOS
          AppLogger.info(
              'Retrying Firebase initialization in $delaySeconds seconds...');
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        } else {
          // All attempts failed - log but don't crash
          AppLogger.logFirebaseInit(success: false, error: e);
          AppLogger.error('Firebase initialization failed after 3 attempts.', e,
              StackTrace.current);
          // Don't rethrow - allow app to continue without Firebase
        }
      } catch (e, stackTrace) {
        AppLogger.error(
            'Firebase initialization attempt $attempt failed', e, stackTrace);

        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          final delaySeconds = attempt * 2;
          AppLogger.info(
              'Retrying Firebase initialization in $delaySeconds seconds...');
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        } else {
          // All attempts failed - log but don't crash
          AppLogger.logFirebaseInit(success: false, error: e);
          AppLogger.error('Firebase initialization failed after 3 attempts.', e,
              stackTrace);
          // Don't rethrow - allow app to continue without Firebase
        }
      }
    }
  }

  // Verify Firebase is initialized before proceeding
  // Allow app to start even if Firebase fails - show error in UI instead
  if (!firebaseInitialized || Firebase.apps.isEmpty) {
    AppLogger.error(
        'Firebase initialization failed. App will start but Firebase features will be unavailable.',
        Exception('Firebase not initialized'),
        StackTrace.current);
    // Continue anyway - the app can show an error screen or work in offline mode
  }

  // Run the app - Firebase may or may not be initialized
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Seervi Kshatriya Samaj Vadodara',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      home: const SplashScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('hi', 'IN'), // Hindi - Default
        Locale('en', 'US'), // English
        Locale('gu', 'IN'), // Gujarati
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Verifies that Firebase config files exist in the expected locations
/// Only checks in debug mode to avoid performance impact in release
bool _verifyFirebaseConfigFiles() {
  // Skip file system checks in release mode for better performance
  if (!const bool.fromEnvironment('dart.vm.product')) {
    try {
      // Get the current working directory (project root)
      final currentDir = Directory.current.path;

      // Check Android config file
      final androidConfig =
          File('$currentDir/android/app/google-services.json');
      final androidExists = androidConfig.existsSync();

      // Check iOS config file
      final iosConfig = File('$currentDir/ios/Runner/GoogleService-Info.plist');
      final iosExists = iosConfig.existsSync();

      if (!androidExists) {
        AppLogger.warning(
            'Android config file not found: android/app/google-services.json');
      }
      if (!iosExists) {
        AppLogger.warning(
            'iOS config file not found: ios/Runner/GoogleService-Info.plist');
      }

      // For iOS, we only need the iOS config file to exist
      // For Android, we only need the Android config file
      // Return true if at least one exists (platform-specific)
      if (Platform.isIOS) {
        return iosExists;
      } else if (Platform.isAndroid) {
        return androidExists;
      }
      return androidExists && iosExists;
    } catch (e) {
      AppLogger.warning('Could not verify Firebase config files: $e');
      return false;
    }
  }
  // In release mode, assume files exist (they should be bundled)
  return true;
}
