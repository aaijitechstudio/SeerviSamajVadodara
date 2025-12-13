import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../auth/presentation/screens/welcome_screen.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Wait a bit more to ensure Firebase is fully initialized
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Verify Firebase is initialized before accessing providers
    try {
      // Check if Firebase is ready
      if (Firebase.apps.isEmpty) {
        // Firebase not ready yet, wait a bit more
        await Future.delayed(const Duration(milliseconds: 1000));
        if (Firebase.apps.isEmpty) {
          // Still not ready, navigate to welcome screen anyway
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
          return;
        }
      }
    } catch (e) {
      // Firebase check failed, navigate to welcome screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
      return;
    }

    if (!mounted) return;

    try {
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authStateProvider);

      authState.when(
        data: (user) {
          if (user != null) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen()),
              );
            }
          } else {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            }
          }
        },
        loading: () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
        },
        error: (error, stackTrace) {
          // If Firebase error, show welcome screen anyway
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
        },
      );
    } catch (e) {
      // If any error occurs, navigate to welcome screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundWhite,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/Aai-Bail_350.gif',
            fit: BoxFit.contain,
            height: 250,
            width: 250,
            errorBuilder: (context, error, stackTrace) {
              // Simple fallback icon if GIF fails to load
              return const Icon(
                Icons.people,
                size: DesignTokens.iconSizeXL,
                color: DesignTokens.primaryOrange,
              );
            },
          ),
        ),
      ),
    );
  }
}
