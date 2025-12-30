import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../features/events/presentation/screens/events_screen.dart';
import '../../../features/committee/presentation/screens/helpline_screen.dart';
import '../../../features/committee/presentation/screens/aarti_screen.dart';
import '../../../features/admin/presentation/screens/admin_panel_screen.dart';

class HomeQuickAccess extends StatelessWidget {
  final bool isAdmin;

  const HomeQuickAccess({
    super.key,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickAccess,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: DesignTokens.fontWeightBold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              context,
              icon: Icons.event,
              title: l10n.events,
              subtitle: l10n.upcoming,
              color: AppColors.featureGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EventsScreen(),
                  ),
                );
              },
            ),
            _buildFeatureCard(
              context,
              icon: Icons.phone,
              title: l10n.helpline,
              subtitle: l10n.emergency,
              color: AppColors.featureRed,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelplineScreen(),
                  ),
                );
              },
            ),
            if (isAdmin)
              _buildFeatureCard(
                context,
                icon: Icons.admin_panel_settings,
                title: l10n.admin,
                subtitle: l10n.panel,
                color: AppColors.featureTeal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminPanelScreen(),
                    ),
                  );
                },
              ),
            _buildFeatureCard(
              context,
              icon: Icons.menu_book,
              title: l10n.aarti,
              subtitle: l10n.aaiMataAarti,
              color: AppColors.primaryOrange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AartiScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Card(
      elevation: DesignTokens.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            border: enabled
                ? null
                : Border.all(
                    color: AppColors.grey300,
                    style: BorderStyle.solid,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: DesignTokens.iconSizeXL,
                color: enabled ? color : AppColors.grey500,
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: enabled ? null : AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingXS),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: enabled ? AppColors.grey600 : AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              if (!enabled)
                const Padding(
                  padding: EdgeInsets.only(top: DesignTokens.spacingS),
                  child: Icon(
                    Icons.lock,
                    size: DesignTokens.iconSizeS,
                    color: AppColors.grey400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
