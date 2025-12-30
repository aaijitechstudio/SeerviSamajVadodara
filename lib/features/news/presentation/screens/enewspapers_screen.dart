import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../domain/models/epaper_model.dart';
import '../../data/epaper_data.dart';
import 'webview_screen.dart';

class ENewspapersScreen extends StatelessWidget {
  const ENewspapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.eNewspapers),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        child: ResponsivePage(
          useSafeArea: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Vadodara Newspapers (No login required)
            _buildNewspaperSection(
              context,
              title: l10n.vadodaraNewspapers,
              icon: Icons.location_city,
              papers: EpaperData.vadodaraPapers,
              l10n: l10n,
            ),
            const SizedBox(height: DesignTokens.spacingL),
            // Rajasthan Newspapers (No login required)
            _buildNewspaperSection(
              context,
              title: l10n.rajasthanNewspapers,
              icon: Icons.location_city,
              papers: EpaperData.rajasthanPapersNoLogin,
              l10n: l10n,
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewspaperSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Epaper> papers,
    required AppLocalizations l10n,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 24),
            const SizedBox(width: DesignTokens.spacingS),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightBold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingM),
        ...papers.map((paper) => _buildEpaperCard(context, paper, l10n)),
      ],
    );
  }

  Widget _buildEpaperCard(
    BuildContext context,
    Epaper paper,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Icon(
            Icons.newspaper,
            color: AppColors.primaryOrange,
            size: 24,
          ),
        ),
        title: Text(
          paper.name,
          style: const TextStyle(
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: () {
          Navigator.of(context).push(
            PageTransitions.fadeSlideRoute(
              WebViewScreen(
                url: paper.url,
                title: paper.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
