import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/responsive_page.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsAndConditionsTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: ResponsivePage(
          useSafeArea: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              l10n.termsAndConditionsTitle,
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
              l10n.acceptanceOfTerms,
              l10n.acceptanceOfTermsContent,
            ),
            _buildSection(
              l10n.useLicense,
              l10n.useLicenseContent,
            ),
            _buildSection(
              l10n.userAccount,
              l10n.userAccountContent,
            ),
            _buildSection(
              l10n.communityGuidelines,
              l10n.communityGuidelinesContent,
            ),
            _buildSection(
              l10n.privacy,
              l10n.privacyContent,
            ),
            _buildSection(
              l10n.limitationOfLiability,
              l10n.limitationOfLiabilityContent,
            ),
            _buildSection(
              l10n.changesToTerms,
              l10n.changesToTermsContent,
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
              l10n.termsContactDescription,
              style: TextStyle(fontSize: DesignTokens.fontSizeM),
            ),
            ],
          ),
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
