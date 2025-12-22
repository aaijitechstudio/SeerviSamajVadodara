import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/utils/network_helper.dart';
import '../../../auth/presentation/screens/welcome_screen.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _loadingRotationAnimation;
  bool _assetsPrecached = false;
  bool _initializationComplete = false;

  @override
  void initState() {
    super.initState();

    // Logo animation controller (scale + fade)
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Loading indicator animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Scale animation for logo
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Fade animation for logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    // Rotation animation for logo (subtle)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Loading indicator rotation animation
    _loadingRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.linear,
      ),
    );

    // Start animations
    _logoAnimationController.forward();
    _loadingAnimationController.repeat();

    // Start initialization
    _initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache assets after the widget tree is built and context is available
    if (!_assetsPrecached) {
      _assetsPrecached = true;
      _precacheAssets();
    }
  }

  Future<void> _precacheAssets() async {
    if (!mounted) return;

    // Precache splash GIF and welcome screen logo in parallel
    final imageProvider = const AssetImage('assets/images/Aai-Bail_350.gif');
    final logoProvider =
        const AssetImage('assets/images/seervisamajvadodara.png');

    try {
      await Future.wait([
        precacheImage(imageProvider, context),
        precacheImage(logoProvider, context),
      ]);
    } catch (e) {
      // Silently handle precache errors - images will load normally if precache fails
      debugPrint('Failed to precache images: $e');
    }
  }

  Future<void> _initializeApp() async {
    // Wait for minimum splash display (2 seconds) and run checks in parallel
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)),
      _checkNetworkAndFirebase(),
    ]);

    if (!mounted) return;

    setState(() {
      _initializationComplete = true;
    });

    // Small delay before navigation for smooth transition
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    await _navigateToNextScreen();
  }

  Future<void> _checkNetworkAndFirebase() async {
    // Check network connectivity
    final hasNetwork = await NetworkHelper.hasNetworkConnectivity();

    if (!mounted) return;

    // Check Firebase initialization
    final isFirebaseInitialized = Firebase.apps.isNotEmpty;

    // Log status
    debugPrint('Network: ${hasNetwork ? "Connected" : "Disconnected"}');
    debugPrint(
        'Firebase: ${isFirebaseInitialized ? "Initialized" : "Not Initialized"}');
  }

  Future<void> _navigateToNextScreen() async {
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
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _buildLogo(),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Loading indicator
                  if (!_initializationComplete)
                    AnimatedBuilder(
                      animation: _loadingAnimationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _loadingRotationAnimation.value * 2 * 3.14159,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryOrange,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Network status indicator
                  connectivityAsync.when(
                    data: (connectivity) {
                      if (connectivity.isConnected) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              NetworkHelper.getConnectivityMessage(
                                connectivity.result,
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'No Internet Connection',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // App name at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          'Seervi Kshatriya Samaj',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vadodara',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/Aai-Bail_350.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryOrange.withOpacity(0.1),
              ),
              child: Icon(
                Icons.people,
                size: DesignTokens.iconSizeXL,
                color: AppColors.primaryOrange,
              ),
            );
          },
        ),
      ),
    );
  }
}
