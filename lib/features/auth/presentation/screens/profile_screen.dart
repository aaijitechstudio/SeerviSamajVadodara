import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/widgets/page_transitions.dart';
import 'login_screen.dart';
import 'samaj_id_card_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: DesignTokens.grey100,
      appBar: CustomAppBar(
        title: l10n.profile,
        showLogo: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.badge_outlined),
            tooltip: l10n.viewIdCard,
            onPressed: () {
              Navigator.of(context).push(
                PageTransitions.fadeSlideRoute(const SamajIdCardScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
            onPressed: () {
              _showLogoutDialog(context, ref);
            },
          ),
        ],
      ),
      body: authState.user == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, authState.user!, l10n, ref),
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic user,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final additionalInfo = user.additionalInfo ?? {};
    final gotra = additionalInfo['gotra'] as String?;
    final vadodaraAddress = additionalInfo['vadodaraAddress'] as String?;
    final nativeAddress = additionalInfo['nativeAddress'] as String?;
    final pratisthanName = additionalInfo['pratisthanName'] as String?;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryOrange.withValues(alpha: 0.1),
            DesignTokens.backgroundWhite,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        child: Column(
          children: [
            _buildProfileHeader(context, user, l10n),
            const SizedBox(height: DesignTokens.spacingM),
            _buildQuickInfoRow(context, user, l10n),
            const SizedBox(height: DesignTokens.spacingM),

            // Personal Information Section
            _buildSection(
              context,
              title: l10n.personalInformation,
              icon: Icons.person_outline,
              showEditButton: true,
              onEdit: () => _showEditProfileDialog(context, user),
              children: [
                _buildInfoRow(
                  context,
                  icon: Icons.person,
                  label: l10n.fullName,
                  value: user.name,
                ),
                if (gotra != null && gotra.isNotEmpty)
                  _buildInfoRow(
                    context,
                    icon: Icons.family_restroom,
                    label: l10n.gotra,
                    value: gotra,
                  ),
                _buildInfoRow(
                  context,
                  icon: Icons.email_outlined,
                  label: l10n.email,
                  value: user.email,
                ),
                _buildInfoRow(
                  context,
                  icon: Icons.phone_outlined,
                  label: l10n.phoneNumber,
                  value: user.phone,
                ),
                if (user.area != null && (user.area as String).isNotEmpty)
                  _buildInfoRow(
                    context,
                    icon: Icons.location_on_outlined,
                    label: l10n.area,
                    value: user.area!,
                  ),
                if (user.profession != null &&
                    (user.profession as String).isNotEmpty)
                  _buildInfoRow(
                    context,
                    icon: Icons.work_outline,
                    label: l10n.profession,
                    value: user.profession!,
                  ),
              ],
            ),

            // Address Information Section
            if ((vadodaraAddress != null && vadodaraAddress.isNotEmpty) ||
                (nativeAddress != null && nativeAddress.isNotEmpty))
              _buildSection(
                context,
                title: l10n.addressInformation,
                icon: Icons.location_city_outlined,
                showEditButton: true,
                onEdit: () => _showEditProfileDialog(context, user),
                children: [
                  if (vadodaraAddress != null && vadodaraAddress.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on,
                      label: l10n.vadodaraAddress,
                      value: vadodaraAddress,
                      isMultiline: true,
                    ),
                  if (nativeAddress != null && nativeAddress.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.home_outlined,
                      label: l10n.nativeAddress,
                      value: nativeAddress,
                      isMultiline: true,
                    ),
                ],
              ),

            // Business Information Section
            if (pratisthanName != null && pratisthanName.isNotEmpty)
              _buildSection(
                context,
                title: l10n.businessInformation,
                icon: Icons.business_outlined,
                showEditButton: true,
                onEdit: () => _showEditProfileDialog(context, user),
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.business,
                    label: l10n.pratisthanName,
                    value: pratisthanName,
                  ),
                ],
              ),

            // Account Status Section
            _buildSection(
              context,
              title: l10n.accountStatus,
              icon: Icons.verified_user_outlined,
              showEditButton: false,
              children: [
                _buildStatusRow(
                  context,
                  icon: Icons.verified,
                  label: l10n.verificationStatus,
                  value: user.isVerified
                      ? l10n.verifiedMember
                      : l10n.pendingVerification,
                  isPositive: user.isVerified,
                ),
                _buildStatusRow(
                  context,
                  icon: Icons.account_circle_outlined,
                  label: l10n.memberType,
                  value: user.isAdmin ? l10n.admin : l10n.members,
                  isPositive: user.isAdmin,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------------

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic user,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryOrangeLight.withValues(alpha: 0.4),
            DesignTokens.primaryOrangeLight.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.primaryOrange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar + camera icon
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignTokens.backgroundWhite,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.shadowMedium,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: DesignTokens.backgroundWhite,
                  child: ClipOval(
                    child: user.profileImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: user.profileImageUrl!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  DesignTokens.primaryOrange,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 45,
                              color: DesignTokens.primaryOrange,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 45,
                            color: DesignTokens.primaryOrange,
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DesignTokens.backgroundWhite,
                    boxShadow: [
                      BoxShadow(
                        color: DesignTokens.shadowMedium,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: DesignTokens.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingM),
          // Name
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: DesignTokens.fontSizeH4,
              fontWeight: DesignTokens.fontWeightBold,
              color: DesignTokens.textOnPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS),
          // Email
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeM,
              color: DesignTokens.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingS),
          // Verified / Pending badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: user.isVerified
                  ? DesignTokens.successColor
                  : DesignTokens.warningColor,
              borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.isVerified ? Icons.verified : Icons.hourglass_top,
                  size: 14,
                  color: DesignTokens.textOnPrimary,
                ),
                const SizedBox(width: DesignTokens.spacingXS),
                Text(
                  user.isVerified
                      ? l10n.verifiedMember
                      : l10n.pendingVerification,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: DesignTokens.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUICK INFO CARDS
  // ---------------------------------------------------------------------------

  Widget _buildQuickInfoRow(
      BuildContext context, dynamic user, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.badge,
            label: 'Samaj ID',
            value: user.samajId ?? l10n.notAssigned,
            color: DesignTokens.primaryOrange,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingM),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.home,
            label: l10n.houseId,
            value: user.houseId ?? l10n.notAssigned,
            color: DesignTokens.featureBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: DesignTokens.iconSizeM,
            color: color,
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: DesignTokens.textSecondary,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    color: DesignTokens.textPrimary,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTIONS
  // ---------------------------------------------------------------------------

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool showEditButton = false,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: DesignTokens.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: DesignTokens.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DesignTokens.primaryOrange.withValues(alpha: 0.1),
                  DesignTokens.primaryOrange.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignTokens.radiusL),
                topRight: Radius.circular(DesignTokens.radiusL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: Icon(
                    icon,
                    size: DesignTokens.iconSizeM,
                    color: DesignTokens.primaryOrange,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSizeXL,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ),
                if (showEditButton && onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: DesignTokens.iconSizeM,
                    color: DesignTokens.primaryOrange,
                    tooltip: 'Edit',
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingM),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INFO ROWS
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignTokens.grey100,
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            child: Icon(
              icon,
              size: DesignTokens.iconSizeM,
              color: DesignTokens.primaryOrange,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: DesignTokens.textSecondary,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    fontWeight: DesignTokens.fontWeightRegular,
                    color: DesignTokens.textPrimary,
                  ),
                  maxLines: isMultiline ? null : 1,
                  overflow: isMultiline
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isPositive,
  }) {
    final Color baseColor =
        isPositive ? DesignTokens.successColor : DesignTokens.warningColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            child: Icon(
              icon,
              size: DesignTokens.iconSizeM,
              color: baseColor,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: DesignTokens.textSecondary,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: baseColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    border: Border.all(
                      color: baseColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      fontWeight: DesignTokens.fontWeightSemiBold,
                      color: baseColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOGS
  // ---------------------------------------------------------------------------

  void _showEditProfileDialog(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        title: const Text('Edit Profile'),
        content:
            const Text('Edit profile functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: DesignTokens.textSecondary,
                fontSize: DesignTokens.fontSizeM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              child: Icon(
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
                  color: DesignTokens.textPrimary,
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
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              l10n.logoutConfirmation,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: DesignTokens.textSecondary,
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
                color: DesignTokens.textSecondary,
                fontSize: DesignTokens.fontSizeM,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authControllerProvider.notifier).signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
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
