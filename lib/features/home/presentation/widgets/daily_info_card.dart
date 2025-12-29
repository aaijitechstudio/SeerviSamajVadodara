import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';

class DailyInfoCard extends StatelessWidget {
  const DailyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMMM yyyy');

    // Get day name
    final dayName = _getDayName(now.weekday, l10n);

    return Container(
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
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: DesignTokens.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryOrange,
                  size: DesignTokens.iconSizeM,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todaysDate,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeS,
                        color: AppColors.textSecondary,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXS / 2),
                    Text(
                      dateFormat.format(now),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXL,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.today,
                  label: l10n.day,
                  value: dayName,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.borderLight,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.access_time,
                  label: l10n.time,
                  value: DateFormat('hh:mm a').format(now),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingM),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingM),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: DesignTokens.iconSizeS,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Text(
                    l10n.dailyInfoNote,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
      child: Column(
        children: [
          Icon(
            icon,
            size: DesignTokens.iconSizeS,
            color: AppColors.primaryOrange,
          ),
          const SizedBox(height: DesignTokens.spacingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXS,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS / 2),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              fontWeight: DesignTokens.fontWeightSemiBold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }
}
