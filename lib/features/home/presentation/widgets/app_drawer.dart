import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../members/domain/models/user_model.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../../committee/presentation/screens/helpline_screen.dart';
import '../../../admin/presentation/screens/admin_panel_screen.dart';
import '../screens/history_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/photo_gallery_screen.dart';

class AppDrawer extends ConsumerWidget {
  final UserModel? user;
  final bool isAdmin;

  const AppDrawer({
    super.key,
    this.user,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.backgroundWhite,
      width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
      child: Column(
        children: [
          // Drawer Header - Compact Modern Design
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryOrange,
                  AppColors.primaryOrangeLight,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.spacingL,
                  DesignTokens.spacingL + 8,
                  DesignTokens.spacingL,
                  DesignTokens.spacingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture with Shadow and Border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.backgroundWhite,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.backgroundWhite,
                        child: user?.profileImageUrl != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user!.profileImageUrl!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 180, // Limit memory usage
                                  memCacheHeight: 180,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryOrange,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.person,
                                    size: DesignTokens.iconSizeXL,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: DesignTokens.iconSizeXL,
                                color: AppColors.primaryOrange,
                              ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    Text(
                      user?.name ?? l10n.samajTitle,
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: DesignTokens.fontSizeL,
                        fontWeight: DesignTokens.fontWeightBold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user != null && user!.email.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: DesignTokens.spacingXS),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: AppColors.textOnPrimary
                                  .withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: DesignTokens.spacingXS),
                            Expanded(
                              child: Text(
                                user!.email,
                                style: TextStyle(
                                  color: AppColors.textOnPrimary
                                      .withValues(alpha: 0.9),
                                  fontSize: DesignTokens.fontSizeS,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable Menu Items
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
              child: Column(
                children: [
                  // Menu Items Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingXS,
                    ),
                    child: Text(
                      l10n.menu,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: DesignTokens.fontSizeS,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Additional Options (only screens NOT in bottom tab bar)
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.event,
                    title: l10n.events,
                    iconColor: AppColors.featurePurple,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const EventsScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.phone,
                    title: l10n.helpline,
                    iconColor: AppColors.featureGreen,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const HelplineScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.history,
                    title: l10n.history,
                    iconColor: AppColors.featureBlue,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageTransitions.fadeSlideRoute(
                          const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.photo_library,
                    title: l10n.photoGallery,
                    iconColor: AppColors.featurePurple,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageTransitions.fadeSlideRoute(
                          const PhotoGalleryScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.contact_support,
                    title: l10n.contactUs,
                    iconColor: AppColors.featureTeal,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageTransitions.slideRoute(const ContactUsScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: l10n.aboutUs,
                    iconColor: AppColors.featureOrange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen()),
                      );
                    },
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: DesignTokens.spacingS),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.admin_panel_settings,
                      title: l10n.admin,
                      iconColor: AppColors.primaryOrange,
                      isAdmin: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          PageTransitions.slideRoute(const AdminPanelScreen()),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: DesignTokens.spacingM),
                  // Settings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingS,
                    ),
                    child: Text(
                      l10n.settings,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: DesignTokens.fontSizeS,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Language Switcher
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.language,
                    title: l10n.selectLanguage,
                    iconColor: AppColors.infoColor,
                    trailing: _buildLanguageIndicator(context, ref),
                    onTap: () {
                      _showLanguageDialog(context, ref);
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingS),
                  // Logout Option
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.logout,
                    title: l10n.signOut,
                    iconColor: AppColors.errorText,
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context, ref);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Fixed Footer
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingS,
            ),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              border: Border(
                top: BorderSide(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                final version = snapshot.data ?? '1.0.0';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: DesignTokens.spacingXS),
                    Text(
                      'Version $version',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: DesignTokens.fontSizeXS,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDestructive = false,
    bool isAdmin = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColors.primaryOrange.withValues(alpha: 0.05)
            : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: isAdmin
            ? Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingS,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? AppColors.errorText
                          : AppColors.textPrimary,
                      fontSize: DesignTokens.fontSizeS,
                      fontWeight: isAdmin
                          ? DesignTokens.fontWeightSemiBold
                          : DesignTokens.fontWeightRegular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: DesignTokens.spacingXS),
                  trailing,
                ] else ...[
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _getAppVersion() async {
    try {
      // For now, return version from pubspec.yaml
      // In production, you can use package_info_plus package
      return '1.0.0';
    } catch (e) {
      return '1.0.0';
    }
  }

  Widget _buildLanguageIndicator(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    String getCurrentLanguageName() {
      switch (currentLocale.languageCode) {
        case 'hi':
          return l10n.hindi;
        case 'gu':
          return l10n.gujarati;
        case 'en':
        default:
          return l10n.english;
      }
    }

    return Text(
      getCurrentLanguageName(),
      style: const TextStyle(
        color: AppColors.primaryOrange,
        fontWeight: DesignTokens.fontWeightSemiBold,
        fontSize: DesignTokens.fontSizeS,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            const Icon(Icons.language, color: AppColors.primaryOrange),
            const SizedBox(width: DesignTokens.spacingM),
            Text(l10n.selectLanguage),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              ref,
              const Locale('hi', 'IN'),
              l10n.hindi,
              currentLocale,
            ),
            _buildLanguageOption(
              context,
              ref,
              const Locale('en', 'US'),
              l10n.english,
              currentLocale,
            ),
            _buildLanguageOption(
              context,
              ref,
              const Locale('gu', 'IN'),
              l10n.gujarati,
              currentLocale,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    String languageName,
    Locale currentLocale,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected
            ? AppColors.primaryOrange
            : AppColors.textSecondary,
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontWeight: isSelected
              ? DesignTokens.fontWeightBold
              : DesignTokens.fontWeightRegular,
          color: isSelected
              ? AppColors.primaryOrange
              : AppColors.textPrimary,
        ),
      ),
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorBackground,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.errorText,
                size: DesignTokens.iconSizeM,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Text(
                l10n.signOut,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.areYouSureLogout,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              l10n.logoutConfirmation,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: DesignTokens.fontSizeM,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(authControllerProvider.notifier).signOut();
              // AuthGate will route to Welcome/Login automatically after sign out.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorText,
              foregroundColor: AppColors.backgroundWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
            ),
            child: Text(
              l10n.signOut,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
