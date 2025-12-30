import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/utils/data_export.dart';
import '../../../../core/utils/auth_preferences.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/responsive_page.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppColors.grey100,
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          children: [
          // Language Settings
          _buildSettingsSection(
            context,
            title: l10n.language,
            icon: Icons.language,
            children: [
              _buildLanguageTile(context, ref, l10n, currentLocale),
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
                  Navigator.of(context).pushNamed('/settings/notifications');
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.history,
                title: LocalizationFallbacks.loginHistory(l10n),
                subtitle: LocalizationFallbacks.viewLoginHistory(l10n),
                onTap: () {
                  Navigator.of(context).pushNamed('/settings/login-history');
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.download_outlined,
                title: LocalizationFallbacks.exportData(l10n),
                subtitle: LocalizationFallbacks.exportDataDescription(l10n),
                onTap: () {
                  _handleDataExport(context, ref, l10n);
                },
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingM),

          // Danger Zone
          _buildSettingsSection(
            context,
            title: LocalizationFallbacks.dangerZone(l10n),
            icon: Icons.warning_outlined,
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.delete_forever_outlined,
                title: LocalizationFallbacks.deleteAccount(l10n),
                subtitle: LocalizationFallbacks.deleteAccountDescription(l10n),
                onTap: () {
                  _showDeleteAccountDialog(context, ref, l10n);
                },
                isDanger: true,
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
                  Navigator.of(context).pushNamed('/terms');
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                onTap: () {
                  Navigator.of(context).pushNamed('/privacy');
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
                      AppColors.textSecondary,
                  fontWeight: DesignTokens.fontWeightRegular,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ],
        ),
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
        color: isDark ? Colors.black : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.1))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.shadowLight,
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
                      ? AppColors.accentGold
                      : AppColors.primaryOrange,
                  size: 24,
                ),
                const SizedBox(width: DesignTokens.spacingS),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
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
    bool isDanger = false,
  }) {
    final iconColor = isDanger ? AppColors.errorColor : AppColors.primaryOrange;
    final backgroundColor = isDanger
        ? AppColors.errorColor.withValues(alpha: 0.1)
        : AppColors.primaryOrange.withValues(alpha: 0.1);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    AppColors.textSecondary,
              ),
            )
          : null,
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale currentLocale,
  ) {
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

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          Icons.translate_outlined,
          color: AppColors.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        l10n.language,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        getCurrentLanguageName(),
        style: TextStyle(
          fontSize: DesignTokens.fontSizeS,
          color: Theme.of(context).textTheme.bodySmall?.color ??
              AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
      ),
      onTap: () {
        _showLanguageDialog(context, ref, l10n);
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.translate_outlined, color: AppColors.primaryOrange),
            const SizedBox(width: DesignTokens.spacingS),
            Text(l10n.selectLanguage),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageDialogOption(
              context,
              ref,
              const Locale('hi', 'IN'),
              l10n.hindi,
              currentLocale,
            ),
            _buildLanguageDialogOption(
              context,
              ref,
              const Locale('en', 'US'),
              l10n.english,
              currentLocale,
            ),
            _buildLanguageDialogOption(
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

  Widget _buildLanguageDialogOption(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    String title,
    Locale currentLocale,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      leading: Icon(
        Icons.language,
        color:
            isSelected ? AppColors.primaryOrange : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected
              ? DesignTokens.fontWeightSemiBold
              : DesignTokens.fontWeightRegular,
          color:
              isSelected ? AppColors.primaryOrange : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: AppColors.primaryOrange,
            )
          : null,
      onTap: () async {
        await ref.read(localeProvider.notifier).setLocale(locale);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
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
          color: AppColors.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        child: Icon(
          themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_6_outlined,
          color: AppColors.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        l10n.themeMode,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        getThemeModeText(),
        style: TextStyle(
          fontSize: DesignTokens.fontSizeS,
          color: Theme.of(context).textTheme.bodySmall?.color ??
              AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
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
            Icon(Icons.lock_outline, color: AppColors.primaryOrange),
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
                color: AppColors.primaryOrange),
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
            ? AppColors.primaryOrange
            : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected
              ? DesignTokens.fontWeightSemiBold
              : DesignTokens.fontWeightRegular,
          color: isSelected
              ? AppColors.primaryOrange
              : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: AppColors.primaryOrange,
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

  Future<void> _handleDataExport(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final authState = ref.read(authControllerProvider);
    final user = authState.user;

    if (user == null) {
      AppUtils.showErrorSnackBar(context, LocalizationFallbacks.pleaseLoginFirst(l10n));
      return;
    }

    // Show format selection dialog
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocalizationFallbacks.exportData(l10n)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocalizationFallbacks.selectExportFormat(l10n)),
            const SizedBox(height: DesignTokens.spacingM),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Text Format'),
              subtitle: const Text('Easy to read'),
              onTap: () => Navigator.of(context).pop('text'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON Format'),
              subtitle: const Text('Machine readable'),
              onTap: () => Navigator.of(context).pop('json'),
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

    if (format == null) return;

    try {
      if (format == 'text') {
        await DataExport.exportAndShareAsText(user);
      } else {
        await DataExport.exportAndShare(user);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationFallbacks.dataExportedSuccessfully(l10n)),
            backgroundColor: AppColors.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppUtils.showErrorSnackBar(
          context,
          '${LocalizationFallbacks.failedToExportData(l10n)}: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.errorColor),
            const SizedBox(width: DesignTokens.spacingS),
            Text(LocalizationFallbacks.deleteAccount(l10n)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationFallbacks.deleteAccountWarning(l10n),
              style: const TextStyle(fontWeight: DesignTokens.fontWeightMedium),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              LocalizationFallbacks.deleteAccountConsequences(l10n),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.errorColor, size: 20),
                  const SizedBox(width: DesignTokens.spacingS),
                  Expanded(
                    child: Text(
                      LocalizationFallbacks.deleteAccountFinalWarning(l10n),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeS,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorColor,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _handleDeleteAccount(context, ref, l10n);
    }
  }

  Future<void> _handleDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final authController = ref.read(authControllerProvider.notifier);
    final authState = ref.read(authControllerProvider);

    if (authState.user == null) {
      AppUtils.showErrorSnackBar(context, LocalizationFallbacks.pleaseLoginFirst(l10n));
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Delete account
      final success = await authController.deleteAccount();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          // Clear all local data
          await AuthPreferences.clearAll();

          // Navigate to login screen
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocalizationFallbacks.accountDeletedSuccessfully(l10n)),
              backgroundColor: AppColors.successColor,
            ),
          );
        } else {
          final error = ref.read(authControllerProvider).error;
          AppUtils.showErrorSnackBar(
            context,
            error ?? LocalizationFallbacks.failedToDeleteAccount(l10n),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        AppUtils.showErrorSnackBar(
          context,
          '${LocalizationFallbacks.failedToDeleteAccount(l10n)}: ${e.toString()}',
        );
      }
    }
  }
}
