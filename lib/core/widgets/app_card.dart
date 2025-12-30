import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import 'animated_card.dart';

/// Base card component with consistent styling using design tokens
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool animated;
  final int animationIndex;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.animated = false,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardWidget = Container(
      margin: margin ?? const EdgeInsets.only(bottom: DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.shadowLight,
            blurRadius: elevation ?? DesignTokens.elevationLow,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusM),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(DesignTokens.spacingL),
            child: child,
          ),
        ),
      ),
    );

    if (animated) {
      return AnimatedCard(
        index: animationIndex,
        onTap: onTap,
        margin: margin,
        padding: padding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        borderRadius: borderRadius,
        child: child,
      );
    }

    return cardWidget;
  }
}

/// Card for displaying statistics
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? AppColors.primaryOrange;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: DesignTokens.iconSizeL,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH6,
              fontWeight: DesignTokens.fontWeightBold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeS,
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Card for displaying information
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: DesignTokens.spacingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeL,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DesignTokens.spacingXS),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeM,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: DesignTokens.spacingM),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Clickable action card
class ActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const ActionCard({
    super.key,
    required this.child,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: child),
          if (icon != null) ...[
            const SizedBox(width: DesignTokens.spacingM),
            Icon(
              icon,
              color: iconColor ?? AppColors.primaryOrange,
              size: DesignTokens.iconSizeM,
            ),
          ],
        ],
      ),
    );
  }
}

