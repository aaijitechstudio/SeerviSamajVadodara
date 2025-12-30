import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/utils/network_helper.dart';
import '../../../../core/widgets/responsive_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _breathingAnimationController;
  late AnimationController _glowAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _loadingRotationAnimation;
  bool _assetsPrecached = false;
  bool _initializationComplete = false;

  @override
  void initState() {
    super.initState();

    // Logo entrance animation controller (scale + fade)
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Breathing/pulse animation controller (spiritual effect)
    _breathingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Glow animation controller (spiritual aura effect)
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Loading indicator animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Scale animation for logo entrance
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Fade animation for logo entrance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    // Breathing animation (gentle pulse - spiritual effect)
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _breathingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Glow animation (spiritual aura effect)
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.35).animate(
      CurvedAnimation(
        parent: _glowAnimationController,
        curve: Curves.easeInOut,
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
    _breathingAnimationController.repeat(reverse: true);
    _glowAnimationController.repeat(reverse: true);
    _loadingAnimationController.repeat();

    // Splash is now display-only (routing handled by AuthGate).
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

    // Precache app logo
    final logoProvider =
        const AssetImage('assets/images/seervisamajvadodara.png');

    try {
      await precacheImage(logoProvider, context);
    } catch (e) {
      // Silently handle precache errors - images will load normally if precache fails
      debugPrint('Failed to precache logo: $e');
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

  // NOTE: routing is handled by `AuthGate`.

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _breathingAnimationController.dispose();
    _glowAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: ResponsivePage(
          useSafeArea: false,
          // Splash should stay full-width (avoid tablet max-width constraining).
          maxContentWidth: 100000,
          child: Stack(
            children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo with Spiritual Theme
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoAnimationController,
                      _breathingAnimationController,
                      _glowAnimationController,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value * _breathingAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildLogo(),
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
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowAnimationController,
      builder: (context, child) {
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundWhite,
                AppColors.primaryOrange.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
            boxShadow: [
              // Animated glow effect (spiritual aura)
              BoxShadow(
                color: AppColors.primaryOrange.withValues(
                  alpha: _glowAnimation.value,
                ),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
              // Base shadow
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
              // Light shadow for depth
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              child: Image.asset(
                'assets/images/seervisamajvadodara.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                      color: AppColors.primaryOrange.withValues(alpha: 0.1),
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
          ),
        );
      },
    );
  }
}
