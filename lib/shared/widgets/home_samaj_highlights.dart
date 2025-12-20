import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/theme/app_colors.dart';

class HomeSamajHighlights extends StatelessWidget {
  const HomeSamajHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.featureGreen.withValues(alpha: 0.08),
            AppColors.featureGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: AppColors.featureGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.featureGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Icon(
                  Icons.star_outline,
                  color: AppColors.featureGreen,
                  size: DesignTokens.iconSizeM,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                'Samaj Highlights',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.featureGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          _buildHighlightItem(
            context,
            icon: Icons.calendar_today,
            title: 'Established in 2014',
            subtitle: 'Serving the community for over 10 years',
            color: AppColors.featureOrange,
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _buildHighlightItem(
            context,
            icon: Icons.verified,
            title: 'Trust Registered',
            subtitle: 'Registration No. A/3256, Vadodara (2016)',
            color: AppColors.featurePurple,
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _buildHighlightItem(
            context,
            icon: Icons.handshake,
            title: 'Community Unity',
            subtitle: 'Preserving traditions, building connections',
            color: AppColors.featureBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Icon(
            icon,
            color: color,
            size: DesignTokens.iconSizeM,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXS / 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
