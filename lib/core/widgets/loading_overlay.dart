import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';

/// Global loading overlay widget
/// Shows a consistent loading indicator across the app
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: DesignTokens.elevationHigh,
                      spreadRadius: DesignTokens.elevationLow,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: DesignTokens.iconSizeXL,
                      height: DesignTokens.iconSizeXL,
                      child: CircularProgressIndicator(
                        strokeWidth: DesignTokens.spacingXS,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange,
                        ),
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: DesignTokens.spacingM),
                      Text(
                        message!,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSizeM,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Full screen loading widget
class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: DesignTokens.iconSizeXL,
              height: DesignTokens.iconSizeXL,
              child: CircularProgressIndicator(
                strokeWidth: DesignTokens.spacingXS,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryOrange,
                ),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline loading indicator
class InlineLoader extends StatelessWidget {
  final double? size;
  final Color? color;

  const InlineLoader({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? DesignTokens.iconSizeM,
      height: size ?? DesignTokens.iconSizeM,
      child: CircularProgressIndicator(
        strokeWidth: DesignTokens.spacingXS,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryOrange,
        ),
      ),
    );
  }
}

/// Button loading indicator
class ButtonLoader extends StatelessWidget {
  final Color? color;

  const ButtonLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DesignTokens.iconSizeM,
      height: DesignTokens.iconSizeM,
      child: CircularProgressIndicator(
        strokeWidth: DesignTokens.spacingXS,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
