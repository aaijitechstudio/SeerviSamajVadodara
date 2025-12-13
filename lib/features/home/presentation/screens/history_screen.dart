import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.history,
        showLogo: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // History Header
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withValues(alpha: 0.1),
                    AppColors.primaryOrange.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: DesignTokens.iconSizeXL,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      l10n.samajHistory,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXL,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            // History Content
            Text(
              l10n.historyContent,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.textPrimary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            // Key Milestones
            Text(
              l10n.keyMilestones,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeL,
                fontWeight: DesignTokens.fontWeightBold,
                color: Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            _buildMilestoneItem(
              context,
              l10n.milestone1,
              l10n.milestone1Description,
            ),
            _buildMilestoneItem(
              context,
              l10n.milestone2,
              l10n.milestone2Description,
            ),
            _buildMilestoneItem(
              context,
              l10n.milestone3,
              l10n.milestone3Description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.grey300,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.shadowLight,
            blurRadius: DesignTokens.elevationLow,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(
              top: DesignTokens.spacingS,
              right: DesignTokens.spacingM,
            ),
            decoration: BoxDecoration(
              color: DesignTokens.primaryOrange,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
