import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';

/// Standardized empty state widget for consistent empty state displays
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final double? iconSize;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize ?? DesignTokens.iconSizeXL * 2,
              color: iconColor ??
                  (isDark ? AppColors.darkTextSecondary : AppColors.grey400),
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightSemiBold,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: DesignTokens.spacingM),
              Text(
                message!,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: DesignTokens.spacingXL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for lists
class EmptyListWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRefresh;

  const EmptyListWidget({
    super.key,
    this.message,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: message ?? 'No items found',
      message: 'Try refreshing to load more',
      action: onRefresh != null
          ? ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            )
          : null,
    );
  }
}

/// Empty state for search results
class EmptySearchWidget extends StatelessWidget {
  final String? query;

  const EmptySearchWidget({
    super.key,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      message: query != null
          ? 'No results for "$query"'
          : 'Try a different search term',
    );
  }
}

