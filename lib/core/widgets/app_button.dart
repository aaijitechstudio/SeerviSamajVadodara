import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import 'loading_overlay.dart';

/// Reusable button widget for consistent styling across the app
enum AppButtonType {
  primary, // Filled button with primary color
  secondary, // Outlined button with primary color border
  text, // Text button
  danger, // Filled button with error color
  success, // Filled button with success color
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidget = _buildButton(context);

    if (isFullWidth) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: buttonWidget,
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: buttonWidget,
      );
    }
  }

  Widget _buildButton(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.grey300,
            disabledForegroundColor: AppColors.grey500,
            elevation: DesignTokens.elevationLow,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            textStyle: TextStyle(
              fontSize: DesignTokens.fontSizeL,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.secondary:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
            disabledForegroundColor: AppColors.grey500,
            side: BorderSide(
              color:
                  isEnabled ? AppColors.primaryOrange : AppColors.grey300,
              width: 2,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            textStyle: TextStyle(
              fontSize: DesignTokens.fontSizeL,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
            disabledForegroundColor: AppColors.grey500,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            textStyle: TextStyle(
              fontSize: DesignTokens.fontSizeL,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorText,
            foregroundColor: AppColors.backgroundWhite,
            disabledBackgroundColor: AppColors.grey300,
            disabledForegroundColor: AppColors.grey500,
            elevation: DesignTokens.elevationLow,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            textStyle: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.success:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successColor,
            foregroundColor: AppColors.backgroundWhite,
            disabledBackgroundColor: AppColors.grey300,
            disabledForegroundColor: AppColors.grey500,
            elevation: DesignTokens.elevationLow,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            textStyle: TextStyle(
              fontSize: DesignTokens.fontSizeL,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return ButtonLoader(
        color: type == AppButtonType.primary ||
                type == AppButtonType.danger ||
                type == AppButtonType.success
            ? AppColors.textOnPrimary
            : AppColors.primaryOrange,
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: DesignTokens.iconSizeM),
          const SizedBox(width: DesignTokens.spacingS),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }

    return Text(label);
  }
}
