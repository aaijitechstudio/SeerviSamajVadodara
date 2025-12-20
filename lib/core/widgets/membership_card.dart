import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Membership Card Widget
/// Displays member information in a card format similar to the reference design
/// Adapts to app theme colors (primaryOrange, etc.)
class MembershipCard extends StatelessWidget {
  final String name;
  final String? samajId; // Samaj ID
  final String? role; // Role/Position (e.g., "सदस्य", "प्रचारक", "President")
  final String? location; // Location/Address
  final String? profileImageUrl;
  final String? gotra;
  final bool isVerified;
  final bool isCommitteeMember;
  final VoidCallback? onTap;

  const MembershipCard({
    super.key,
    required this.name,
    this.samajId,
    this.role,
    this.location,
    this.profileImageUrl,
    this.gotra,
    this.isVerified = false,
    this.isCommitteeMember = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          top: DesignTokens.spacingS,
          bottom: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.shadowMedium,
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Logo and Organization Name
            _buildHeader(context, isDark),

            const SizedBox(height: DesignTokens.spacingM),

            // Main Content Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Card with Decorative Background
                  _buildProfileImageCard(context, isDark),

                  const SizedBox(width: DesignTokens.spacingM),

                  // Member Details
                  Expanded(
                    child: _buildMemberDetails(context, isDark, l10n),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DesignTokens.spacingM),

            // Footer Section
            _buildFooter(context, isDark),

            const SizedBox(height: DesignTokens.spacingS),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.1),
            AppColors.primaryOrangeLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DesignTokens.radiusL),
          topRight: Radius.circular(DesignTokens.radiusL),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.2),
              border: Border.all(
                color: AppColors.primaryOrange,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/seervisamajvadodara.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.people,
                    color: AppColors.primaryOrange,
                    size: DesignTokens.iconSizeM,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingS),
          // Organization Name
          Expanded(
            child: Text(
              l10n != null
                  ? '${l10n.samajTitle} ${l10n.samajVadodara}'
                  : 'Seervi Kshatriya Samaj Vadodara',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeL,
                fontWeight: DesignTokens.fontWeightBold,
                color: AppColors.primaryOrange,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageCard(BuildContext context, bool isDark) {
    return Stack(
      children: [
        // Decorative Background Card
        Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrangeDark.withValues(alpha: 0.8),
                AppColors.primaryOrange.withValues(alpha: 0.9),
                AppColors.primaryOrangeDark.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: profileImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.primaryOrange.withValues(alpha: 0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.backgroundWhite,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildDefaultProfileImage(),
                  )
                : _buildDefaultProfileImage(),
          ),
        ),
        // Role Badge Overlapping Bottom-Left
        if (role != null && role!.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: DesignTokens.spacingXS / 2,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentGold,
                    AppColors.secondarySaffron,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(DesignTokens.radiusM),
                  topRight: Radius.circular(DesignTokens.radiusS),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: 14,
                    color: AppColors.backgroundWhite,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    role!,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: AppColors.backgroundWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.3),
            AppColors.primaryOrangeDark.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: DesignTokens.iconSizeXL,
          color: AppColors.backgroundWhite.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildMemberDetails(
      BuildContext context, bool isDark, AppLocalizations? l10n) {
    // Build name with Shree, Name, Ji, and Gotra
    String displayName =
        l10n != null ? '${l10n.shree} $name ${l10n.ji}' : 'Shree $name Ji';
    if (gotra != null && gotra!.isNotEmpty) {
      displayName = '$displayName $gotra';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Samaj ID
        if (samajId != null && samajId!.isNotEmpty) ...[
          Text(
            l10n != null ? '${l10n.samajId}: $samajId' : 'Samaj ID: $samajId',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              fontWeight: DesignTokens.fontWeightSemiBold,
              color:
                  isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS),
        ],

        // Member Name with Shree, Ji, and Gotra
        Text(
          displayName,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeXXL,
            fontWeight: DesignTokens.fontWeightBold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: DesignTokens.spacingXS),

        // Role/Status Badge (if not already shown in profile card badge)
        if (role != null && role!.isNotEmpty && !isCommitteeMember)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingXS / 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              role!,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                fontWeight: DesignTokens.fontWeightSemiBold,
                color: AppColors.primaryOrange,
              ),
            ),
          ),

        // Location
        if (location != null && location!.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingS),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: DesignTokens.spacingXS),
              Expanded(
                child: Text(
                  location!.toUpperCase(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],

        // Verified Badge
        if (isVerified) ...[
          const SizedBox(height: DesignTokens.spacingS),
          Row(
            children: [
              Icon(
                Icons.verified,
                size: 16,
                color: AppColors.successColor,
              ),
              const SizedBox(width: DesignTokens.spacingXS),
              Text(
                'Verified',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: AppColors.successColor,
                  fontWeight: DesignTokens.fontWeightMedium,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Disclaimer
          Text(
            '*Not for official use',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXS,
              fontStyle: FontStyle.italic,
              color:
                  isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
            ),
          ),
          // Attribution
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrangeLight,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingXS),
              Text(
                l10n != null
                    ? 'Generated By - ${l10n.samajTitle} ${l10n.samajVadodara}'
                    : 'Generated By - Shree Seervi Samaj Vadodara',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXS,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
