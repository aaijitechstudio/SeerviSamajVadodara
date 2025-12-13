import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import 'notifications_settings_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : DesignTokens.grey100,
      appBar: CustomAppBar(
        title: l10n.settings,
        showLogo: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        children: [
          // Language Settings
          _buildSettingsSection(
            context,
            title: l10n.language,
            icon: Icons.language,
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
          const SizedBox(height: DesignTokens.spacingM),

          // Account Settings
          _buildSettingsSection(
            context,
            title: l10n.account,
            icon: Icons.account_circle_outlined,
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.lock_outline,
                title: l10n.changePassword,
                subtitle: l10n.changePasswordDescription,
                onTap: () {
                  _showChangePasswordDialog(context, l10n);
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications_outlined,
                title: l10n.notifications,
                subtitle: l10n.manageNotifications,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsSettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingM),

          // Appearance Settings
          _buildSettingsSection(
            context,
            title: l10n.appearance,
            icon: Icons.palette_outlined,
            children: [
              _buildThemeToggle(context, ref, l10n),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingM),

          // About Section
          _buildSettingsSection(
            context,
            title: l10n.about,
            icon: Icons.info_outline,
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.description_outlined,
                title: l10n.termsAndConditions,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              FutureBuilder<String>(
                future: _getAppVersion(),
                builder: (context, snapshot) {
                  final version = snapshot.data ?? '1.0.0';
                  return _buildSettingsTile(
                    context,
                    icon: Icons.info,
                    title: l10n.appVersion,
                    subtitle: 'Version $version',
                    onTap: null,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingXL),

          // Developed By Footer
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
              child: Text(
                'Developed By - Aaiji Tech Studio - Vadodara',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXS,
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.6) ??
                      DesignTokens.textSecondary,
                  fontWeight: DesignTokens.fontWeightRegular,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : DesignTokens.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.1))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : DesignTokens.shadowLight,
            blurRadius: DesignTokens.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingM),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDark
                      ? DesignTokens.accentGold
                      : DesignTokens.primaryOrange,
                  size: 24,
                ),
                const SizedBox(width: DesignTokens.spacingS),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: isDark ? Colors.white : DesignTokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DesignTokens.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          icon,
          color: DesignTokens.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              DesignTokens.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    DesignTokens.textSecondary,
              ),
            )
          : null,
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: DesignTokens.textTertiary,
            )
          : null,
      onTap: onTap,
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
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignTokens.primaryOrange.withValues(alpha: 0.15)
              : DesignTokens.grey100,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          Icons.language,
          color: isSelected
              ? DesignTokens.primaryOrange
              : DesignTokens.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: isSelected
              ? DesignTokens.fontWeightSemiBold
              : DesignTokens.fontWeightRegular,
          color: isSelected
              ? DesignTokens.primaryOrange
              : DesignTokens.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: DesignTokens.primaryOrange,
            )
          : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
    );
  }

  Widget _buildThemeToggle(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final themeMode = ref.watch(themeModeProvider);

    String getThemeModeText() {
      switch (themeMode) {
        case ThemeMode.light:
          return l10n.lightMode;
        case ThemeMode.dark:
          return l10n.darkMode;
        default:
          return l10n.systemDefault;
      }
    }

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DesignTokens.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_6_outlined,
          color: DesignTokens.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        l10n.themeMode,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              DesignTokens.textPrimary,
        ),
      ),
      subtitle: Text(
        getThemeModeText(),
        style: TextStyle(
          fontSize: DesignTokens.fontSizeS,
          color: Theme.of(context).textTheme.bodySmall?.color ??
              DesignTokens.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: DesignTokens.textTertiary,
      ),
      onTap: () {
        _showThemeDialog(context, ref, l10n);
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: DesignTokens.primaryOrange),
            const SizedBox(width: DesignTokens.spacingS),
            Text(l10n.changePassword),
          ],
        ),
        content: Text(l10n.changePasswordFeatureComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentThemeMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.brightness_6_outlined,
                color: DesignTokens.primaryOrange),
            const SizedBox(width: DesignTokens.spacingS),
            Text(l10n.themeMode),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              ref,
              ThemeMode.light,
              l10n.lightMode,
              Icons.light_mode,
              currentThemeMode,
            ),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.dark,
              l10n.darkMode,
              Icons.dark_mode,
              currentThemeMode,
            ),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.system,
              l10n.systemDefault,
              Icons.brightness_6_outlined,
              currentThemeMode,
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

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    String title,
    IconData icon,
    ThemeMode currentMode,
  ) {
    final isSelected = currentMode == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? DesignTokens.primaryOrange
            : DesignTokens.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected
              ? DesignTokens.fontWeightSemiBold
              : DesignTokens.fontWeightRegular,
          color: isSelected
              ? DesignTokens.primaryOrange
              : DesignTokens.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: DesignTokens.primaryOrange,
            )
          : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.of(context).pop();
      },
    );
  }

  Future<String> _getAppVersion() async {
    try {
      return '1.0.0';
    } catch (e) {
      return '1.0.0';
    }
  }
}
