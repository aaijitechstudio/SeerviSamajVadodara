import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../members/providers/members_provider.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../../committee/presentation/screens/helpline_screen.dart';
import '../../../committee/presentation/screens/aarti_screen.dart';
import '../../../admin/presentation/screens/admin_panel_screen.dart';
import '../widgets/daily_info_card.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;
    final membersState = ref.watch(membersControllerProvider);
    final totalMembers = membersState.members.length;
    final verifiedMembers =
        membersState.members.where((m) => m.isVerified).length;

    return Column(
      children: [
        CustomAppBar(
          showLogo: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Find the parent Scaffold (MainNavigationScreen's Scaffold) that has the drawer
                final scaffoldState =
                    context.findAncestorStateOfType<ScaffoldState>();
                scaffoldState?.openDrawer();
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: l10n.notifications,
              onPressed: () {
                // TODO: Navigate to notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.comingSoon)),
                );
              },
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section - Only show if user is authenticated
                if (user != null)
                  Container(
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
                          backgroundColor: DesignTokens.backgroundWhite,
                          child: user.profileImageUrl != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: user.profileImageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Text(
                                      user.name.isNotEmpty
                                          ? user.name[0].toUpperCase()
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
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : 'U',
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
                                l10n.welcomeUser(user.name.split(' ').first),
                                style: TextStyle(
                                  color: DesignTokens.textOnPrimary,
                                  fontSize: DesignTokens.fontSizeXXL,
                                  fontWeight: DesignTokens.fontWeightBold,
                                ),
                              ),
                              if (user.area != null)
                                Text(
                                  user.area!,
                                  style: TextStyle(
                                    color: DesignTokens.textOnPrimary
                                        .withValues(alpha: 0.9),
                                    fontSize: DesignTokens.fontSizeM,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (authState.isLoading)
                  // Show loading state while checking authentication
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  // User not authenticated - should redirect to login
                  // This should not normally be visible as splash screen handles routing
                  Container(
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
                                  color: Colors.orange.shade700
                                      .withValues(alpha: 0.8),
                                  fontSize: DesignTokens.fontSizeM,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: DesignTokens.spacingL),

                // Daily Information Card
                const DailyInfoCard(),

                const SizedBox(height: DesignTokens.spacingL),

                // Community Stats Section
                _buildCommunityStats(
                    context, l10n, totalMembers, verifiedMembers),

                const SizedBox(height: DesignTokens.spacingL),

                // Samaj Highlights Section
                _buildSamajHighlights(context, l10n),

                const SizedBox(height: DesignTokens.spacingL),

                // Trust Information Card
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    border: Border.all(
                      color: DesignTokens.primaryOrange.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryOrange,
                            size: DesignTokens.iconSizeM,
                          ),
                          const SizedBox(width: DesignTokens.spacingS),
                          Text(
                            l10n.trustInfo,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeL,
                              fontWeight: DesignTokens.fontWeightBold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      Text(
                        '${l10n.trustRegistrationNo} ${l10n.trustRegistrationNumber}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeM,
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.trustRegistrationDate,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeM,
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${l10n.established}: ${l10n.establishedYear}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeM,
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingL),

                // Quick Access Cards
                Text(
                  l10n.quickAccess,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: Icons.event,
                      title: l10n.events,
                      subtitle: l10n.upcoming,
                      color: AppColors.featureGreen,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const EventsScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.phone,
                      title: l10n.helpline,
                      subtitle: l10n.emergency,
                      color: AppColors.featureRed,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const HelplineScreen()),
                        );
                      },
                    ),
                    if (isAdmin)
                      _buildFeatureCard(
                        context,
                        icon: Icons.admin_panel_settings,
                        title: l10n.admin,
                        subtitle: l10n.panel,
                        color: AppColors.featureTeal,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AdminPanelScreen()),
                          );
                        },
                      ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.menu_book,
                      title: l10n.aarti,
                      subtitle: l10n.aaiMataAarti,
                      color: AppColors.primaryOrange,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AartiScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Card(
      elevation: DesignTokens.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            border: enabled
                ? null
                : Border.all(
                    color: DesignTokens.grey300, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: DesignTokens.iconSizeXL,
                color: enabled ? color : DesignTokens.grey500,
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: enabled ? null : DesignTokens.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingXS),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: enabled ? DesignTokens.grey600 : DesignTokens.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              if (!enabled)
                Padding(
                  padding: const EdgeInsets.only(top: DesignTokens.spacingS),
                  child: Icon(
                    Icons.lock,
                    size: DesignTokens.iconSizeS,
                    color: DesignTokens.grey400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityStats(
    BuildContext context,
    AppLocalizations l10n,
    int totalMembers,
    int verifiedMembers,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.08),
            AppColors.primaryOrangeLight.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Icon(
                  Icons.people_outline,
                  color: AppColors.primaryOrange,
                  size: DesignTokens.iconSizeM,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                'Community Stats',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.people,
                  value: totalMembers.toString(),
                  label: 'Total Members',
                  color: AppColors.featureBlue,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.verified_user,
                  value: verifiedMembers.toString(),
                  label: 'Verified',
                  color: AppColors.featureGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: DesignTokens.iconSizeL,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH6,
              fontWeight: DesignTokens.fontWeightBold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeS,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSamajHighlights(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.featureGreen.withValues(alpha: 0.08),
            AppColors.featureGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: AppColors.featureGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.featureGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Icon(
                  Icons.star_outline,
                  color: AppColors.featureGreen,
                  size: DesignTokens.iconSizeM,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                'Samaj Highlights',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.featureGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          _buildHighlightItem(
            context,
            icon: Icons.calendar_today,
            title: 'Established in 2014',
            subtitle: 'Serving the community for over 10 years',
            color: AppColors.featureOrange,
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _buildHighlightItem(
            context,
            icon: Icons.verified,
            title: 'Trust Registered',
            subtitle: 'Registration No. A/3256, Vadodara (2016)',
            color: AppColors.featurePurple,
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _buildHighlightItem(
            context,
            icon: Icons.handshake,
            title: 'Community Unity',
            subtitle: 'Preserving traditions, building connections',
            color: AppColors.featureBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
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
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXS / 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
