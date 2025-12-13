import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Design Tokens - All spacing, typography defined here
/// Colors are now in AppColors for centralized theme management
/// Following Google Material Design 3 principles
class DesignTokens {
  // Private constructor to prevent instantiation
  DesignTokens._();

  // ==================== Colors (Deprecated - Use AppColors) ====================
  // These are kept for backward compatibility but will be removed
  // Use AppColors instead for all color references
  @Deprecated('Use AppColors.primaryOrange instead')
  static const Color primaryOrange = AppColors.primaryOrange;
  @Deprecated('Use AppColors.primaryOrangeDark instead')
  static const Color primaryOrangeDark = AppColors.primaryOrangeDark;
  @Deprecated('Use AppColors.primaryOrangeLight instead')
  static const Color primaryOrangeLight = AppColors.primaryOrangeLight;
  @Deprecated('Use AppColors.secondarySaffron instead')
  static const Color secondarySaffron = AppColors.secondarySaffron;
  @Deprecated('Use AppColors.accentGold instead')
  static const Color accentGold = AppColors.accentGold;
  @Deprecated('Use AppColors.backgroundCream instead')
  static const Color backgroundCream = AppColors.backgroundCream;
  @Deprecated('Use AppColors.backgroundWhite instead')
  static const Color backgroundWhite = AppColors.backgroundWhite;
  @Deprecated('Use AppColors.surfaceColor instead')
  static const Color surfaceColor = AppColors.surfaceColor;
  @Deprecated('Use AppColors.textPrimary instead')
  static const Color textPrimary = AppColors.textPrimary;
  @Deprecated('Use AppColors.textSecondary instead')
  static const Color textSecondary = AppColors.textSecondary;
  @Deprecated('Use AppColors.textTertiary instead')
  static const Color textTertiary = AppColors.textTertiary;
  @Deprecated('Use AppColors.textOnPrimary instead')
  static const Color textOnPrimary = AppColors.textOnPrimary;
  @Deprecated('Use AppColors.errorColor instead')
  static const Color errorColor = AppColors.errorColor;
  @Deprecated('Use AppColors.successColor instead')
  static const Color successColor = AppColors.successColor;
  @Deprecated('Use AppColors.warningColor instead')
  static const Color warningColor = AppColors.warningColor;
  @Deprecated('Use AppColors.infoColor instead')
  static const Color infoColor = AppColors.infoColor;
  @Deprecated('Use AppColors.borderLight instead')
  static const Color borderLight = AppColors.borderLight;
  @Deprecated('Use AppColors.borderMedium instead')
  static const Color borderMedium = AppColors.borderMedium;
  @Deprecated('Use AppColors.dividerColor instead')
  static const Color dividerColor = AppColors.dividerColor;
  @Deprecated('Use AppColors.grey100 instead')
  static const Color grey100 = AppColors.grey100;
  @Deprecated('Use AppColors.grey200 instead')
  static const Color grey200 = AppColors.grey200;
  @Deprecated('Use AppColors.grey300 instead')
  static const Color grey300 = AppColors.grey300;
  @Deprecated('Use AppColors.grey400 instead')
  static const Color grey400 = AppColors.grey400;
  @Deprecated('Use AppColors.grey500 instead')
  static const Color grey500 = AppColors.grey500;
  @Deprecated('Use AppColors.grey600 instead')
  static const Color grey600 = AppColors.grey600;
  @Deprecated('Use AppColors.grey700 instead')
  static const Color grey700 = AppColors.grey700;
  @Deprecated('Use AppColors.grey800 instead')
  static const Color grey800 = AppColors.grey800;
  @Deprecated('Use AppColors.grey900 instead')
  static const Color grey900 = AppColors.grey900;
  @Deprecated('Use AppColors.featureBlue instead')
  static const Color featureBlue = AppColors.featureBlue;
  @Deprecated('Use AppColors.featureOrange instead')
  static const Color featureOrange = AppColors.featureOrange;
  @Deprecated('Use AppColors.featureGreen instead')
  static const Color featureGreen = AppColors.featureGreen;
  @Deprecated('Use AppColors.featurePurple instead')
  static const Color featurePurple = AppColors.featurePurple;
  @Deprecated('Use AppColors.featureRed instead')
  static const Color featureRed = AppColors.featureRed;
  @Deprecated('Use AppColors.featureTeal instead')
  static const Color featureTeal = AppColors.featureTeal;
  @Deprecated('Use AppColors.shadowLight instead')
  static const Color shadowLight = AppColors.shadowLight;
  @Deprecated('Use AppColors.shadowMedium instead')
  static const Color shadowMedium = AppColors.shadowMedium;
  @Deprecated('Use AppColors.shadowDark instead')
  static const Color shadowDark = AppColors.shadowDark;

  // ==================== Spacing ====================
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ==================== Border Radius ====================
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0;

  // ==================== Elevation ====================
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ==================== Typography ====================
  static const String fontFamily = 'Nunito';

  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeH6 = 24.0;
  static const double fontSizeH5 = 28.0;
  static const double fontSizeH4 = 32.0;
  static const double fontSizeH3 = 36.0;
  static const double fontSizeH2 = 40.0;
  static const double fontSizeH1 = 48.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // ==================== Animation Durations ====================
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ==================== Icon Sizes ====================
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
}
