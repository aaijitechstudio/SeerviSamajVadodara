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

  // Initialize Firebase - required for app to work
  // MUST complete before any Firebase services are accessed
  // Firebase.initializeApp() will auto-detect config from google-services.json
  // and GoogleService-Info.plist files
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      AppLogger.info('Initializing Firebase...');
      await Firebase.initializeApp();

      // Verify initialization was successful
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase.initializeApp() completed but no apps found');
      }

      // Additional verification - try to access a Firebase service
      try {
        final app = Firebase.app();
        AppLogger.info(
            'Firebase initialized successfully. App name: ${app.name}');
      } catch (e) {
        AppLogger.warning('Firebase app created but verification failed: $e');
        // Continue anyway - might work
      }

      AppLogger.logFirebaseInit(success: true);
    } else {
      AppLogger.info(
          'Firebase already initialized (${Firebase.apps.length} app(s))');
    }
  } catch (e, stackTrace) {
    // Log error with full details - Firebase is required for this app
    AppLogger.logFirebaseInit(success: false, error: e);
    AppLogger.error('Firebase initialization failed', e, stackTrace);

    // Don't continue if Firebase fails - show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Firebase Initialization Failed',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${e.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please check:\n'
                      '1. google-services.json is in android/app/\n'
                      '2. GoogleService-Info.plist is in ios/Runner/\n'
                      '3. Firebase project is properly configured\n'
                      '4. Run: flutter clean && flutter pub get',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'For more help, visit:\n'
                      'https://firebase.google.com/docs/flutter/setup',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

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
      localizationsDelegates: [
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
