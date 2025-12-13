import 'package:flutter/material.dart';

/// Centralized color system - All app colors defined here
/// Change colors here to update theme across entire app
class AppColors {
  AppColors._();

  // ==================== Primary Colors ====================
  // Change these to update primary theme colors
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color primaryOrangeDark = Color(0xFFE65100);
  static const Color primaryOrangeLight = Color(0xFFFFB74D);

  // Secondary Colors
  static const Color secondarySaffron = Color(0xFFE65100);
  static const Color accentGold = Color(0xFFF2C237);

  // ==================== Background Colors ====================
  static const Color backgroundCream = Color(0xFFFFF9F2);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // ==================== Text Colors ====================
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ==================== Semantic Colors ====================
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color errorBackground = Color(0xFFFFEBEE);
  static const Color errorBorder = Color(0xFFEF9A9A);
  static const Color errorText = Color(0xFFC62828);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  // ==================== Border Colors ====================
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);

  // ==================== Divider Colors ====================
  static const Color dividerColor = Color(0xFFE0E0E0);

  // ==================== Grey Colors ====================
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== Feature Card Colors ====================
  static const Color featureBlue = Color(0xFF2196F3);
  static const Color featureOrange = Color(0xFFFF9800);
  static const Color featureGreen = Color(0xFF4CAF50);
  static const Color featurePurple = Color(0xFF9C27B0);
  static const Color featureRed = Color(0xFFF44336);
  static const Color featureTeal = Color(0xFF009688);

  // ==================== Shadow Colors ====================
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // ==================== Dark Mode Colors ====================
  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Colors.black;
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF333333);
}
