import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import 'app_colors.dart';

/// Standardized text styles for consistent typography across the app
/// All text styles use DesignTokens for sizing and AppColors for colors
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // ==================== Headlines ====================

  /// Headline 1 - Largest heading (48px)
  static TextStyle headline1(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH1,
      fontWeight: DesignTokens.fontWeightBold,
      color: theme.textTheme.headlineLarge?.color ?? AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }

  /// Headline 2 - Large heading (40px)
  static TextStyle headline2(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH2,
      fontWeight: DesignTokens.fontWeightBold,
      color: theme.textTheme.headlineMedium?.color ?? AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }

  /// Headline 3 - Medium heading (36px)
  static TextStyle headline3(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH3,
      fontWeight: DesignTokens.fontWeightSemiBold,
      color: theme.textTheme.headlineSmall?.color ?? AppColors.textPrimary,
    );
  }

  /// Headline 4 - Small heading (32px)
  static TextStyle headline4(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH4,
      fontWeight: DesignTokens.fontWeightSemiBold,
      color: theme.textTheme.titleLarge?.color ?? AppColors.textPrimary,
    );
  }

  /// Headline 5 - Extra small heading (28px)
  static TextStyle headline5(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH5,
      fontWeight: DesignTokens.fontWeightSemiBold,
      color: theme.textTheme.titleMedium?.color ?? AppColors.textPrimary,
    );
  }

  /// Headline 6 - Smallest heading (24px)
  static TextStyle headline6(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeH6,
      fontWeight: DesignTokens.fontWeightSemiBold,
      color: theme.textTheme.titleSmall?.color ?? AppColors.textPrimary,
    );
  }

  // ==================== Body Text ====================

  /// Body Large - Primary body text (18px)
  static TextStyle bodyLarge(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeXL,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary,
      height: 1.5,
    );
  }

  /// Body Medium - Standard body text (16px)
  static TextStyle bodyMedium(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeL,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary,
      height: 1.5,
    );
  }

  /// Body Small - Secondary body text (14px)
  static TextStyle bodySmall(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeM,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodySmall?.color ?? AppColors.textSecondary,
      height: 1.5,
    );
  }

  /// Body Extra Small - Tertiary body text (12px)
  static TextStyle bodyExtraSmall(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeS,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
      height: 1.4,
    );
  }

  // ==================== Caption ====================

  /// Caption - Small helper text (12px)
  static TextStyle caption(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeS,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
      height: 1.4,
    );
  }

  /// Caption Small - Extra small helper text (10px)
  static TextStyle captionSmall(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeXS,
      fontWeight: DesignTokens.fontWeightRegular,
      color: theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
      height: 1.3,
    );
  }

  // ==================== Button Text ====================

  /// Button - Standard button text (16px, semi-bold)
  static TextStyle button(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeL,
      fontWeight: DesignTokens.fontWeightSemiBold,
      color: theme.textTheme.labelLarge?.color ?? AppColors.textOnPrimary,
      letterSpacing: 0.5,
    );
  }

  /// Button Small - Small button text (14px, medium)
  static TextStyle buttonSmall(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeM,
      fontWeight: DesignTokens.fontWeightMedium,
      color: theme.textTheme.labelMedium?.color ?? AppColors.textOnPrimary,
      letterSpacing: 0.3,
    );
  }

  // ==================== Label Text ====================

  /// Label - Form label text (14px, medium)
  static TextStyle label(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeM,
      fontWeight: DesignTokens.fontWeightMedium,
      color: theme.textTheme.labelLarge?.color ?? AppColors.textPrimary,
    );
  }

  /// Label Small - Small label text (12px, medium)
  static TextStyle labelSmall(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: DesignTokens.fontSizeS,
      fontWeight: DesignTokens.fontWeightMedium,
      color: theme.textTheme.labelMedium?.color ?? AppColors.textSecondary,
    );
  }

  // ==================== Override Colors ====================

  /// Helper method to override text color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Helper method to override font weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Helper method to override font size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}

