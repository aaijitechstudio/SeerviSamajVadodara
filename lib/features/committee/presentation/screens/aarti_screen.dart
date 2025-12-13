import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/constants/design_tokens.dart';

class AartiScreen extends StatelessWidget {
  const AartiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aaiMataAarti),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DesignTokens.primaryOrange.withValues(alpha: 0.1),
              DesignTokens.backgroundCream,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Devotional Invocations
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: DesignTokens.backgroundWhite,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.shadowLight,
                      blurRadius: DesignTokens.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.devotionalInvocations,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeL,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    _buildInvocationText(l10n.shriGaneshayaNamah),
                    const SizedBox(height: DesignTokens.spacingS),
                    _buildInvocationText(l10n.shriAaiMatajiNamah),
                    const SizedBox(height: DesignTokens.spacingS),
                    _buildInvocationText(l10n.shriKhetlajiNamah),
                    const SizedBox(height: DesignTokens.spacingS),
                    _buildInvocationText(l10n.shriCharbhujaJiNamah),
                  ],
                ),
              ),

              const SizedBox(height: DesignTokens.spacingXL),

              // Aarti Title
              Text(
                l10n.aaiMataAarti,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH4,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.primaryOrange,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: DesignTokens.spacingXL),

              // Aarti Verses
              _buildAartiVerse(context, l10n.aartiVerse1),
              const SizedBox(height: DesignTokens.spacingL),
              _buildAartiVerse(context, l10n.aartiVerse2),
              const SizedBox(height: DesignTokens.spacingL),
              _buildAartiVerse(context, l10n.aartiVerse3),

              const SizedBox(height: DesignTokens.spacingXL),

              // Community Request
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: DesignTokens.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  border: Border.all(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: DesignTokens.primaryOrange,
                      size: DesignTokens.iconSizeL,
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      l10n.communityRequest,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeM,
                        color: DesignTokens.textPrimary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: DesignTokens.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvocationText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: DesignTokens.fontSizeL,
        fontWeight: DesignTokens.fontWeightMedium,
        color: DesignTokens.primaryOrange,
        fontFamily: DesignTokens.fontFamily,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAartiVerse(BuildContext context, String verse) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        color: DesignTokens.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.shadowLight,
            blurRadius: DesignTokens.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        verse,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeL,
          fontWeight: DesignTokens.fontWeightRegular,
          color: DesignTokens.textPrimary,
          height: 1.8,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
