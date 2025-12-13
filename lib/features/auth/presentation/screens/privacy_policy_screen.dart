import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.privacyPolicyTitle,
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
            Text(
              l10n.privacyPolicyTitle,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeH3,
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              '${l10n.lastUpdated}: ${DateTime.now().year}',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            _buildSection(
              l10n.informationWeCollect,
              l10n.informationWeCollectContent,
            ),
            _buildSection(
              l10n.howWeUseYourInformation,
              l10n.howWeUseYourInformationContent,
            ),
            _buildSection(
              l10n.informationSharing,
              l10n.informationSharingContent,
            ),
            _buildSection(
              l10n.dataSecurity,
              l10n.dataSecurityContent,
            ),
            _buildSection(
              l10n.yourRights,
              l10n.yourRightsContent,
            ),
            _buildSection(
              l10n.childrensPrivacy,
              l10n.childrensPrivacyContent,
            ),
            _buildSection(
              l10n.changesToThisPolicy,
              l10n.changesToThisPolicyContent,
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            Text(
              l10n.contactUs,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.privacyContactDescription,
              style: TextStyle(fontSize: DesignTokens.fontSizeM),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXL,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingS),
          Text(
            content,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              height: 1.5, // Standard line height ratio
            ),
          ),
        ],
      ),
    );
  }
}
