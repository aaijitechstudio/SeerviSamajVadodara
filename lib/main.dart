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

        // Use default initialization - it will auto-detect config files
        await Firebase.initializeApp();

        // Verify initialization was successful
        if (Firebase.apps.isEmpty) {
          throw Exception(
              'Firebase.initializeApp() completed but no apps found');
        }

        // Additional verification - try to access a Firebase service
        try {
          final app = Firebase.app();
          AppLogger.info(
              'Firebase initialized successfully. App name: ${app.name}');
          AppLogger.logFirebaseInit(success: true);
          firebaseInitialized = true;
          break; // Success, exit retry loop
        } catch (e) {
          AppLogger.warning('Firebase app created but verification failed: $e');
          if (attempt < 3) {
            // Wait before retry
            await Future.delayed(Duration(seconds: attempt));
            continue;
          } else {
            // Last attempt failed
            throw Exception(
                'Firebase verification failed after all attempts: $e');
          }
        }
      } on FirebaseException catch (e) {
        // Handle Firebase-specific errors
        AppLogger.error(
            'Firebase initialization attempt $attempt failed with FirebaseException',
            e,
            StackTrace.current);

        // Check for specific error codes
        if (e.code == 'not-initialized' ||
            e.message?.contains('not been correctly initialized') == true) {
          AppLogger.warning('Firebase config files may not be processed. '
              'This usually requires a clean rebuild:\n'
              '1. Run: flutter clean\n'
              '2. Run: flutter pub get\n'
              '3. For iOS: cd ios && pod install && cd ..\n'
              '4. Run: flutter run');
        }

        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          await Future.delayed(Duration(seconds: attempt));
          continue;
        } else {
          // All attempts failed
          AppLogger.logFirebaseInit(success: false, error: e);
          AppLogger.error('Firebase initialization failed after 3 attempts.', e,
              StackTrace.current);
          rethrow; // Re-throw to prevent app from starting without Firebase
        }
      } catch (e, stackTrace) {
        AppLogger.error(
            'Firebase initialization attempt $attempt failed', e, stackTrace);

        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          await Future.delayed(Duration(seconds: attempt));
          continue;
        } else {
          // All attempts failed
          AppLogger.logFirebaseInit(success: false, error: e);
          AppLogger.error('Firebase initialization failed after 3 attempts.', e,
              stackTrace);
          rethrow; // Re-throw to prevent app from starting without Firebase
        }
      }
    }
  }

  // Verify Firebase is initialized before proceeding
  if (!firebaseInitialized || Firebase.apps.isEmpty) {
    throw Exception(
        'Firebase initialization failed. Cannot start the app without Firebase.');
  }

  // Run the app - Firebase is now guaranteed to be initialized
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
      // Check Android config file
      final androidConfig = File('android/app/google-services.json');
      final androidExists = androidConfig.existsSync();

      // Check iOS config file
      final iosConfig = File('ios/Runner/GoogleService-Info.plist');
      final iosExists = iosConfig.existsSync();

      if (!androidExists) {
        AppLogger.warning(
            'Android config file not found: android/app/google-services.json');
      }
      if (!iosExists) {
        AppLogger.warning(
            'iOS config file not found: ios/Runner/GoogleService-Info.plist');
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
