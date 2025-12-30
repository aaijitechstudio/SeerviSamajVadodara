import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/app_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  DateTime? _lastBackPressAt;

  @override
  void initState() {
    super.initState();
    // Precache logo image for smooth display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/seervisamajvadodara.png'),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scaffoldBgColor = theme.scaffoldBackgroundColor;
    final textColor =
        theme.textTheme.bodySmall?.color ?? AppColors.textSecondary;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;
    final appBarHeight = AppBar().preferredSize.height;

    // Calculate available height for content
    final availableHeight =
        screenHeight - safeAreaTop - safeAreaBottom - appBarHeight;

    // Responsive sizing based on screen height
    final isSmallScreen = availableHeight < 700;
    final isMediumScreen = availableHeight >= 700 && availableHeight < 900;

    // Responsive dimensions
    final logoSize = isSmallScreen ? 100.0 : (isMediumScreen ? 120.0 : 140.0);
    final horizontalPadding = screenWidth < 360 ? 16.0 : 24.0;
    final verticalPadding = isSmallScreen ? 8.0 : 16.0;
    final titleFontSize = isSmallScreen
        ? DesignTokens.fontSizeH6
        : (isMediumScreen
            ? DesignTokens.fontSizeH5 * 0.9
            : DesignTokens.fontSizeH5);
    final spacingMultiplier =
        isSmallScreen ? 0.7 : (isMediumScreen ? 0.85 : 1.0);

    return WillPopScope(
      onWillPop: () async {
        if (!Platform.isAndroid) return true;

        final now = DateTime.now();
        if (_lastBackPressAt == null ||
            now.difference(_lastBackPressAt!) > const Duration(seconds: 2)) {
          _lastBackPressAt = now;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }

        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
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
              scaffoldBgColor,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Samaj Logo with Enhanced Design
                      // Samaj Logo with Enhanced Design (same as welcome screen)
                      Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.backgroundWhite,
                              AppColors.primaryOrange
                                  .withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusXL),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange
                                  .withValues(alpha: 0.15),
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
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusL),
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

                      SizedBox(height: 12 * spacingMultiplier),

                      // App Title with Gradient Effect
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.primaryOrange,
                            AppColors.primaryOrangeDark,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          l10n.samajTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: DesignTokens.fontWeightBold,
                            color: AppColors.textOnPrimary,
                            fontSize: titleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 4 * spacingMultiplier),

                      Text(
                        l10n.samajVadodara,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryOrangeDark,
                          fontWeight: DesignTokens.fontWeightSemiBold,
                          letterSpacing: 0.5,
                          fontSize: isSmallScreen
                              ? DesignTokens.fontSizeM
                              : DesignTokens.fontSizeL,
                        ),
                      ),

                      SizedBox(height: 16 * spacingMultiplier),

                      // App Features Section - Enhanced Design with Flexible spacing
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFeatureItem(
                              context,
                              icon: Icons.people,
                              title: l10n.memberDirectory,
                              description: l10n.connectWithCommunity,
                              color: AppColors.featureBlue,
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: 8 * spacingMultiplier),
                            _buildFeatureItem(
                              context,
                              icon: Icons.event,
                              title: l10n.events,
                              description: l10n.stayUpdated,
                              color: AppColors.featureGreen,
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: 8 * spacingMultiplier),
                            _buildFeatureItem(
                              context,
                              icon: Icons.newspaper,
                              title: l10n.news,
                              description: l10n.latestAnnouncements,
                              color: AppColors.featurePurple,
                              isSmallScreen: isSmallScreen,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12 * spacingMultiplier),

                      SizedBox(height: 14 * spacingMultiplier),

                      // Login Button
                      AppButton(
                        label: l10n.login,
                        type: AppButtonType.primary,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                      ),

                      SizedBox(height: 12 * spacingMultiplier),

                      // Register Button
                      AppButton(
                        label: l10n.registerMembersOnly,
                        type: AppButtonType.secondary,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                      ),

                      SizedBox(height: 16 * spacingMultiplier),

                      // Powered By Footer
                      Center(
                        child: Text(
                          l10n.poweredBy,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXS *
                                (isSmallScreen ? 0.9 : 1.0),
                            color: textColor.withValues(alpha: 0.6),
                            fontWeight: DesignTokens.fontWeightRegular,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
    bool isSmallScreen = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM * (isSmallScreen ? 0.9 : 1.0),
        vertical: DesignTokens.spacingM * (isSmallScreen ? 0.8 : 1.0),
      ),
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
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
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
              size: isSmallScreen
                  ? DesignTokens.iconSizeS
                  : DesignTokens.iconSizeM,
            ),
          ),
          SizedBox(width: DesignTokens.spacingM * (isSmallScreen ? 0.8 : 1.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen
                        ? DesignTokens.fontSizeS
                        : DesignTokens.fontSizeM,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmallScreen
                        ? DesignTokens.fontSizeXS
                        : DesignTokens.fontSizeS,
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
