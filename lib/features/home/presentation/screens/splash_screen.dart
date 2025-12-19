import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _precacheAssets();
    _animationController.forward();
    _navigateToNextScreen();
  }

  Future<void> _precacheAssets() async {
    // Precache splash GIF and welcome screen logo in parallel
    final imageProvider = const AssetImage('assets/images/Aai-Bail_350.gif');
    final logoProvider =
        const AssetImage('assets/images/seervisamajvadodara.png');

    await Future.wait([
      precacheImage(imageProvider, context),
      precacheImage(logoProvider, context),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for minimum splash display (1.5s) and run checks in parallel
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      _checkAuthState(),
    ]);

    if (!mounted) return;
  }

  Future<void> _checkAuthState() async {
    // Small delay to ensure Firebase is ready (already initialized in main.dart)
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Verify Firebase is initialized
    if (Firebase.apps.isEmpty) {
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
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => user != null
                    ? const MainNavigationScreen()
                    : const WelcomeScreen(),
              ),
            );
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
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
        },
      );
    } catch (e) {
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
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/Aai-Bail_350.gif',
            fit: BoxFit.contain,
            height: 250,
            width: 250,
            cacheWidth: 250,
            cacheHeight: 250,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.people,
                size: DesignTokens.iconSizeXL,
                color: AppColors.primaryOrange,
              );
            },
          ),
        ),
      ),
    );
  }
}
