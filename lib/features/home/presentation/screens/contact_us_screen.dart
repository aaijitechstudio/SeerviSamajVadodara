import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.contactUs,
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
            // Contact Header
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
                    Icons.contact_support,
                    size: DesignTokens.iconSizeXL,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      l10n.getInTouch,
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
            // Office Address
            _buildContactCard(
              context,
              icon: Icons.location_on,
              title: l10n.officeAddress,
              content: l10n.officeAddressDetails,
              color: AppColors.featureBlue,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            // Phone
            _buildContactCard(
              context,
              icon: Icons.phone,
              title: l10n.phoneNumber,
              content: l10n.phoneNumberDetails,
              color: AppColors.featureGreen,
              onTap: () => _makePhoneCall(l10n.phoneNumberDetails),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            // Email
            _buildContactCard(
              context,
              icon: Icons.email,
              title: l10n.emailAddress,
              content: l10n.emailAddressDetails,
              color: AppColors.featurePurple,
              onTap: () => _sendEmail(l10n.emailAddressDetails),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            // Website
            _buildContactCard(
              context,
              icon: Icons.language,
              title: l10n.website,
              content: l10n.websiteDetails,
              color: AppColors.featureTeal,
              onTap: () => _openWebsite(l10n.websiteDetails),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: DesignTokens.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: DesignTokens.iconSizeL,
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
                        fontSize: DesignTokens.fontSizeS,
                        color: AppColors.textSecondary,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXS),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeM,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: DesignTokens.iconSizeS,
                  color: AppColors.grey500,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _openWebsite(String url) async {
    final Uri websiteUri =
        Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    }
  }
}
