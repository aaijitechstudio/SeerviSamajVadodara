import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/app_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: const [LanguageSwitcher()],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryOrange.withValues(alpha: 0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Samaj Logo with Enhanced Design
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        AppColors.primaryOrange.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                      child: Image.asset(
                        'assets/images/seervisamajvadodara.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.people,
                            size: DesignTokens.iconSizeXL,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App Title with Gradient Effect
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrangeDark,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    l10n.samajTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: Colors.white,
                          fontSize: DesignTokens.fontSizeH5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  l10n.samajVadodara,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryOrangeDark,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        letterSpacing: 0.5,
                      ),
                ),

                const SizedBox(height: 20),

                // App Features Section - Enhanced Design
                _buildFeatureItem(
                  context,
                  icon: Icons.people,
                  title: l10n.memberDirectory,
                  description: l10n.connectWithCommunity,
                  color: AppColors.featureBlue,
                ),
                const SizedBox(height: 10),
                _buildFeatureItem(
                  context,
                  icon: Icons.event,
                  title: l10n.events,
                  description: l10n.stayUpdated,
                  color: AppColors.featureGreen,
                ),
                const SizedBox(height: 10),
                _buildFeatureItem(
                  context,
                  icon: Icons.newspaper,
                  title: l10n.news,
                  description: l10n.latestAnnouncements,
                  color: AppColors.featurePurple,
                ),

                const SizedBox(height: 14),

                // Trust Information Card - Enhanced Design
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryOrange.withValues(alpha: 0.08),
                        AppColors.primaryOrangeLight.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                    border: Border.all(
                      color: AppColors.primaryOrange.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryOrange.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified,
                          color: AppColors.primaryOrange,
                          size: DesignTokens.iconSizeM,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingM),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.trustInfo,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                fontWeight: DesignTokens.fontWeightBold,
                                color: AppColors.primaryOrangeDark,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.trustRegistrationNumber,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeXS,
                                fontWeight: DesignTokens.fontWeightMedium,
                                color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color ??
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Login Button
                AppButton(
                  label: l10n.login,
                  type: AppButtonType.primary,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // Register Button
                AppButton(
                  label: l10n.registerMembersOnly,
                  type: AppButtonType.secondary,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Powered By Footer
                Center(
                  child: Text(
                    'Powered by - Seervi Kshatriya Samaj - Vadodara',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXS,
                      color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.6) ??
                          AppColors.textSecondary,
                      fontWeight: DesignTokens.fontWeightRegular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM, vertical: DesignTokens.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        AppColors.textSecondary,
                    fontWeight: DesignTokens.fontWeightRegular,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
