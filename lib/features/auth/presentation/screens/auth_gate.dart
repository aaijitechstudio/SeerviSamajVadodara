import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/auth_provider.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';
import '../../../home/presentation/screens/splash_screen.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';
import 'login_history_screen.dart';
import 'notifications_settings_screen.dart';
import 'onboarding_screen.dart';
import 'phone_login_screen.dart';
import 'privacy_policy_screen.dart';
import 'samaj_id_card_screen.dart';
import 'settings_screen.dart';
import 'signup_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'welcome_screen.dart';
import '../../../community/presentation/screens/post_detail_screen.dart';

/// Centralized auth-based navigation gate.
///
/// Owns a nested Navigator so that:
/// - All app routes live under this gate
/// - On login/logout we can reset the stack reliably
/// - Screens don't need to self-redirect
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  ProviderSubscription<AsyncValue<User?>>? _authSubscription;

  bool _minSplashDone = false;
  bool _authResolved = false;
  User? _latestFirebaseUser;
  String? _activeRoot;

  @override
  void initState() {
    super.initState();

    // Listen once for auth state changes.
    _authSubscription = ref.listenManual<AsyncValue<User?>>(
      authStateProvider,
      (previous, next) {
        next.when(
          data: (user) {
            _authResolved = true;
            _latestFirebaseUser = user;
            _maybeRoute();
          },
          loading: () {
            // Keep splash visible until resolved.
          },
          error: (_, __) {
            _authResolved = true;
            _latestFirebaseUser = null;
            _maybeRoute();
          },
        );
      },
    );

    // Apply current value once (Riverpod versions differ on fireImmediately support).
    final current = ref.read(authStateProvider);
    current.when(
      data: (user) {
        _authResolved = true;
        _latestFirebaseUser = user;
      },
      loading: () {},
      error: (_, __) {
        _authResolved = true;
        _latestFirebaseUser = null;
      },
    );

    // Keep a minimum splash time for smoother UX.
    Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() => _minSplashDone = true);
      _maybeRoute();
    });
  }

  @override
  void dispose() {
    _authSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navKey,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SplashScreen(),
            );
          case '/welcome':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const WelcomeScreen(),
            );
          case '/login':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LoginScreen(),
            );
          case '/forgot-password':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const ForgotPasswordScreen(),
            );
          case '/signup':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SignupScreen(),
            );
          case '/phone-login':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PhoneLoginScreen(),
            );
          case '/onboarding':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const OnboardingScreen(),
            );
          case '/main':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const MainNavigationScreen(),
            );
          case '/settings':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SettingsScreen(),
            );
          case '/settings/notifications':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const NotificationsSettingsScreen(),
            );
          case '/settings/login-history':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LoginHistoryScreen(),
            );
          case '/terms':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const TermsAndConditionsScreen(),
            );
          case '/privacy':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PrivacyPolicyScreen(),
            );
          case '/samaj-id-card':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SamajIdCardScreen(),
            );
          case PostDetailScreen.routeName:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PostDetailScreen(),
            );
          default:
            return MaterialPageRoute(
              settings: const RouteSettings(name: '/welcome'),
              builder: (_) => const WelcomeScreen(),
            );
        }
      },
    );
  }

  void _maybeRoute() {
    // Don't route until we have shown splash for at least the minimum time.
    if (!_minSplashDone) return;

    // If we haven't received auth state yet, wait (keeps splash visible).
    if (!_authResolved) return;

    final target = (_latestFirebaseUser != null) ? '/main' : '/welcome';

    final nav = _navKey.currentState;
    if (nav == null) return;

    if (_activeRoot == target) return;
    _activeRoot = target;

    nav.pushNamedAndRemoveUntil(target, (route) => false);
  }
}


