import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

/// Google Sign In Button following Google's official branding guidelines
///
/// Design specifications per https://developers.google.com/identity/branding-guidelines:
/// - Platform-specific padding (iOS: 16px left, 12px after logo, 16px after text)
/// - Platform-specific padding (Android: 12px left, 10px after logo, 12px after text)
/// - Theme-aware (Light, Dark, Neutral)
/// - Uses official Google Sign In assets
/// - Supports different button types (Sign in, Sign up, Continue)
class GoogleSignInButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final GoogleSignInButtonType buttonType;
  final GoogleSignInButtonShape shape;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.buttonType = GoogleSignInButtonType.signIn,
    this.shape = GoogleSignInButtonShape.rectangular,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = _isDarkMode(context, themeMode);
    final platform = Platform.isIOS ? 'iOS' : 'Android';
    final platformLower = Platform.isIOS ? 'ios' : 'android';
    final theme = _getThemeName(isDark);
    final shapePrefix = shape == GoogleSignInButtonShape.pill ? 'rd' : 'sq';
    final buttonTypeSuffix = _getButtonTypeSuffix(buttonType);

    // Determine device pixel ratio for asset selection
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final densitySuffix = _getDensitySuffix(devicePixelRatio);

    // Build asset path - folder uses capitalized platform name, filename uses lowercase
    final assetPath =
        'assets/images/google_signin/$platform/png$densitySuffix/$theme/${platformLower}_${theme}_${shapePrefix}_$buttonTypeSuffix$densitySuffix.png';

    // Platform-specific padding per Google guidelines
    final horizontalPadding = Platform.isIOS ? 16.0 : 12.0;
    final logoRightPadding = Platform.isIOS ? 12.0 : 10.0;
    final textRightPadding = Platform.isIOS ? 16.0 : 12.0;

    return SizedBox(
      width: double.infinity,
      height: 40, // Standard button height
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide.none,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: shape == GoogleSignInButtonShape.pill
                ? BorderRadius.circular(20)
                : BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Stack(
          children: [
            // Background image with proper asset
            Positioned.fill(
              child: Image.asset(
                assetPath,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to custom button if asset not found
                  return _buildFallbackButton(
                    context,
                    isDark,
                    horizontalPadding,
                    logoRightPadding,
                    textRightPadding,
                  );
                },
              ),
            ),
            // Loading indicator overlay if needed
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Fallback button if assets are not available
  Widget _buildFallbackButton(
    BuildContext context,
    bool isDark,
    double horizontalPadding,
    double logoRightPadding,
    double textRightPadding,
  ) {
    // Colors per Google guidelines
    final backgroundColor = isDark
        ? const Color(0xFF131314) // Dark theme
        : const Color(0xFFFFFFFF); // Light theme
    final borderColor = isDark
        ? const Color(0xFF8E918F) // Dark theme border
        : const Color(0xFF747775); // Light theme border
    final textColor = isDark
        ? const Color(0xFFE3E3E3) // Dark theme text
        : const Color(0xFF1F1F1F); // Light theme text

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: shape == GoogleSignInButtonShape.pill
            ? BorderRadius.circular(20)
            : BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Google "G" logo (standard color on white background)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Google "G" logo representation
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4), // Google blue
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: logoRightPadding),
            // Button text
            Text(
              _getButtonText(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500, // Roboto Medium equivalent
                color: textColor,
                letterSpacing: 0.25,
                height: 20 / 14, // 14/20 line height per guidelines
              ),
            ),
            SizedBox(width: textRightPadding),
            if (isLoading) ...[
              const SizedBox(width: 12),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (buttonType) {
      case GoogleSignInButtonType.signIn:
        return 'Sign in with Google';
      case GoogleSignInButtonType.signUp:
        return 'Sign up with Google';
      case GoogleSignInButtonType.continueWith:
        return 'Continue with Google';
      case GoogleSignInButtonType.none:
        return 'Google';
    }
  }

  String _getButtonTypeSuffix(GoogleSignInButtonType type) {
    switch (type) {
      case GoogleSignInButtonType.signIn:
        return 'SI';
      case GoogleSignInButtonType.signUp:
        return 'SU';
      case GoogleSignInButtonType.continueWith:
        return 'ctn';
      case GoogleSignInButtonType.none:
        return 'na';
    }
  }

  String _getThemeName(bool isDark) {
    // For now, we'll use light/dark. Neutral can be added if needed
    return isDark ? 'dark' : 'light';
  }

  String _getDensitySuffix(double devicePixelRatio) {
    // Select appropriate density based on device pixel ratio
    if (devicePixelRatio >= 3.5) {
      return '@4x';
    } else if (devicePixelRatio >= 2.5) {
      return '@3x';
    } else if (devicePixelRatio >= 1.5) {
      return '@2x';
    } else {
      return '@1x';
    }
  }

  bool _isDarkMode(BuildContext context, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}

/// Button type options per Google guidelines
enum GoogleSignInButtonType {
  signIn,
  signUp,
  continueWith,
  none,
}

/// Button shape options per Google guidelines
enum GoogleSignInButtonShape {
  rectangular, // Square corners
  pill, // Rounded corners
}
