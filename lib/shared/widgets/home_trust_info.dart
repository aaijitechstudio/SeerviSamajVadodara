import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class HomeTrustInfo extends StatelessWidget {
  const HomeTrustInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryOrange,
                size: DesignTokens.iconSizeM,
              ),
              const SizedBox(width: DesignTokens.spacingS),
              Text(
                l10n.trustInfo,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingS),
          Text(
            '${l10n.trustRegistrationNo} ${l10n.trustRegistrationNumber}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.textPrimary,
            ),
          ),
          Text(
            l10n.trustRegistrationDate,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.textPrimary,
            ),
          ),
          Text(
            '${l10n.established}: ${l10n.establishedYear}',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
