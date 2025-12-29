import '../../l10n/app_localizations.dart';

/// Helper extension for safely accessing localization strings that may not exist
extension LocalizationHelper on AppLocalizations {
  /// Safely get a localization string with fallback
  String safeGet(String Function(AppLocalizations) getter, String fallback) {
    try {
      return getter(this);
    } catch (e) {
      return fallback;
    }
  }
}

/// Helper class for new localization strings that haven't been added yet
class LocalizationFallbacks {
  static String rememberMe(AppLocalizations? l10n) => 'Remember Me';
  static String loginHistory(AppLocalizations? l10n) => 'Login History';
  static String viewLoginHistory(AppLocalizations? l10n) => 'View your recent login activities';
  static String exportData(AppLocalizations? l10n) => 'Export My Data';
  static String exportDataDescription(AppLocalizations? l10n) => 'Download your personal data (GDPR)';
  static String dangerZone(AppLocalizations? l10n) => 'Danger Zone';
  static String deleteAccount(AppLocalizations? l10n) => 'Delete Account';
  static String deleteAccountDescription(AppLocalizations? l10n) => 'Permanently delete your account and all data';
  static String pleaseLoginFirst(AppLocalizations? l10n) => 'Please login first';
  static String selectExportFormat(AppLocalizations? l10n) => 'Select export format:';
  static String dataExportedSuccessfully(AppLocalizations? l10n) => 'Data exported successfully';
  static String failedToExportData(AppLocalizations? l10n) => 'Failed to export data';
  static String deleteAccountWarning(AppLocalizations? l10n) => 'Are you sure you want to delete your account? This action cannot be undone.';
  static String deleteAccountConsequences(AppLocalizations? l10n) => 'This will permanently delete:\n• Your account\n• All your posts\n• All your comments\n• Your profile data\n• All associated information';
  static String deleteAccountFinalWarning(AppLocalizations? l10n) => 'This action is permanent and cannot be reversed.';
  static String accountDeletedSuccessfully(AppLocalizations? l10n) => 'Account deleted successfully';
  static String failedToDeleteAccount(AppLocalizations? l10n) => 'Failed to delete account';
  static String clear(AppLocalizations? l10n) => 'Clear';
  static String noLoginHistory(AppLocalizations? l10n) => 'No login history';
  static String loginHistoryWillAppearHere(AppLocalizations? l10n) => 'Your recent login activities will appear here';
  static String clearLoginHistory(AppLocalizations? l10n) => 'Clear Login History';
  static String clearLoginHistoryConfirmation(AppLocalizations? l10n) => 'Are you sure you want to clear all login history? This action cannot be undone.';
  static String loginHistoryCleared(AppLocalizations? l10n) => 'Login history cleared';
}

