import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../constants/design_tokens.dart';

class AppTheme {
  // Use AppColors for all theme colors - centralized color management
  static const Color primaryColor = AppColors.primaryOrange;
  static const Color secondaryColor = AppColors.secondarySaffron;
  static const Color accentColor = AppColors.accentGold;
  static const Color errorColor = AppColors.errorColor;
  static const Color backgroundColor = AppColors.backgroundCream;
  static const Color surfaceColor = AppColors.surfaceColor;
  static const Color textPrimaryColor = AppColors.textPrimary;
  static const Color textSecondaryColor = AppColors.textSecondary;

  static ThemeData get lightTheme {
    final nunitoFont = GoogleFonts.nunitoTextTheme();

    return ThemeData(
      useMaterial3: true,
      textTheme: nunitoFont.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: AppColors.primaryOrange,
        secondary: AppColors.secondarySaffron,
        error: AppColors.errorColor,
        surface: AppColors.surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.1),
        foregroundColor: AppColors.primaryOrange,
        elevation: DesignTokens.elevationNone,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: kToolbarHeight, // Ensure consistent height across all app bars
        titleTextStyle: GoogleFonts.nunito(
          fontSize: DesignTokens.fontSizeH6,
          fontWeight: DesignTokens.fontWeightSemiBold,
          color: AppColors.primaryOrange,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primaryOrange,
        ),
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.dividerColor,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.textOnPrimary,
          elevation: DesignTokens.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: DesignTokens.fontSizeL,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
      ),
      scaffoldBackgroundColor: AppColors.backgroundCream,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingM,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: DesignTokens.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        color: AppColors.surfaceColor,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    final nunitoFont = GoogleFonts.nunitoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: nunitoFont.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentGold,
        brightness: Brightness.dark,
        primary: AppColors.accentGold, // Gold for primary
        secondary: AppColors.primaryOrange,
        error: AppColors.errorColor,
        surface: AppColors.darkSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: DesignTokens.elevationNone,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: DesignTokens.fontSizeH6,
          fontWeight: DesignTokens.fontWeightSemiBold,
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          foregroundColor: Colors.black,
          elevation: DesignTokens.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: DesignTokens.fontSizeL,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackground,
        hintStyle:
            TextStyle(color: AppColors.darkTextPrimary.withValues(alpha: 0.6)),
        labelStyle: const TextStyle(color: AppColors.darkTextPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(
            color: AppColors.accentGold,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingM,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: DesignTokens.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        color: AppColors.darkSurface,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentGold,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
