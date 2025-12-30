import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../features/members/domain/models/user_model.dart';

class HomeWelcomeSection extends StatelessWidget {
  final UserModel? user;
  final bool isLoading;

  const HomeWelcomeSection({
    super.key,
    required this.user,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.login,
              color: Colors.orange.shade700,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please Login',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: DesignTokens.fontSizeXL,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXS),
                  Text(
                    'You need to login to access the app',
                    style: TextStyle(
                      color: Colors.orange.shade700.withValues(alpha: 0.8),
                      fontSize: DesignTokens.fontSizeM,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.backgroundWhite,
            child: user!.profileImageUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user!.profileImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      memCacheWidth: 120, // Limit memory usage
                      memCacheHeight: 120,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Text(
                        user!.name.isNotEmpty
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeH6,
                          color: Theme.of(context).primaryColor,
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                      ),
                    ),
                  )
                : Text(
                    user!.name.isNotEmpty ? user!.name[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeH6,
                      color: Theme.of(context).primaryColor,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeUser(user!.name.split(' ').first),
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: DesignTokens.fontSizeXXL,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
                if (user!.area != null)
                  Text(
                    user!.area!,
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      fontSize: DesignTokens.fontSizeM,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
