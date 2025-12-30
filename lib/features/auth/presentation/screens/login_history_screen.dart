import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/auth_preferences.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/responsive_page.dart';

class LoginHistoryScreen extends ConsumerStatefulWidget {
  const LoginHistoryScreen({super.key});

  @override
  ConsumerState<LoginHistoryScreen> createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends ConsumerState<LoginHistoryScreen> {
  List<Map<String, dynamic>> _loginHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoginHistory();
  }

  Future<void> _loadLoginHistory() async {
    setState(() => _isLoading = true);
    final history = await AuthPreferences.getLoginHistory();
    setState(() {
      _loginHistory = history;
      _isLoading = false;
    });
  }

  String _formatTimestamp(String? timestampStr) {
    if (timestampStr == null || timestampStr.isEmpty) return 'Unknown';
    try {
      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
      }
    } catch (e) {
      return timestampStr;
    }
  }

  String _getMethodIcon(String? method) {
    switch (method?.toLowerCase()) {
      case 'google':
        return '🔐';
      case 'phone':
        return '📱';
      case 'email':
      default:
        return '✉️';
    }
  }

  String _getMethodLabel(String? method) {
    switch (method?.toLowerCase()) {
      case 'google':
        return 'Google Sign-In';
      case 'phone':
        return 'Phone/OTP';
      case 'email':
      default:
        return 'Email/Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationFallbacks.loginHistory(l10n)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_loginHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearHistoryDialog(context, l10n),
              tooltip: LocalizationFallbacks.clear(l10n),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loginHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: DesignTokens.spacingM),
                      Text(
                        LocalizationFallbacks.noLoginHistory(l10n),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeL,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      Text(
                        LocalizationFallbacks.loginHistoryWillAppearHere(l10n),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeM,
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLoginHistory,
                  child: ResponsivePage(
                    useSafeArea: false,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(DesignTokens.spacingM),
                      itemCount: _loginHistory.length,
                      itemBuilder: (context, index) {
                      final activity = _loginHistory[index];
                      final email = activity['email']?.toString() ?? 'Unknown';
                      final timestamp = activity['timestamp']?.toString();
                      final method = activity['method']?.toString();
                      final deviceInfo = activity['deviceInfo']?.toString();

                      return Card(
                        margin: const EdgeInsets.only(
                            bottom: DesignTokens.spacingS),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.primaryOrange.withValues(alpha: 0.1),
                            child: Text(
                              _getMethodIcon(method),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(
                            _getMethodLabel(method),
                            style: const TextStyle(
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: DesignTokens.spacingXS),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeS,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: DesignTokens.spacingXS),
                              Text(
                                _formatTimestamp(timestamp),
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeXS,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              if (deviceInfo != null &&
                                  deviceInfo != 'Unknown') ...[
                                const SizedBox(height: DesignTokens.spacingXS),
                                Text(
                                  deviceInfo,
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSizeXS,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                      },
                    ),
                  ),
                ),
    );
  }

  Future<void> _showClearHistoryDialog(
      BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocalizationFallbacks.clearLoginHistory(l10n)),
        content: Text(
          LocalizationFallbacks.clearLoginHistoryConfirmation(l10n),
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
            child: Text(LocalizationFallbacks.clear(l10n)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthPreferences.clearLoginHistory();
      if (mounted) {
        _loadLoginHistory();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationFallbacks.loginHistoryCleared(l10n)),
          ),
        );
      }
    }
  }
}
