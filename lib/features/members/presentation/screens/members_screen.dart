import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/members_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../domain/models/user_model.dart';
import 'member_detail_screen.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedArea;
  String? _selectedProfession;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(membersControllerProvider.notifier).loadMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isAuthenticated = authState.user != null;
    final membersState = ref.watch(membersControllerProvider);
    final membersController = ref.read(membersControllerProvider.notifier);

    // Note: Filter dialog removed - areas and professions variables kept for future use

    // Apply filters
    var filteredMembers = membersState.members;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filteredMembers = filteredMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            (member.houseId?.toLowerCase().contains(query) ?? false) ||
            (member.area?.toLowerCase().contains(query) ?? false) ||
            (member.profession?.toLowerCase().contains(query) ?? false) ||
            member.phone.contains(query);
      }).toList();
    }

    if (_selectedArea != null) {
      filteredMembers =
          filteredMembers.where((m) => m.area == _selectedArea).toList();
    }

    if (_selectedProfession != null) {
      filteredMembers = filteredMembers
          .where((m) => m.profession == _selectedProfession)
          .toList();
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.memberDirectory,
        showLogo: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, house ID, area, profession...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Active Filters
          if (_selectedArea != null || _selectedProfession != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (_selectedArea != null)
                    Chip(
                      label: Text('Area: $_selectedArea'),
                      onDeleted: () {
                        setState(() {
                          _selectedArea = null;
                        });
                      },
                    ),
                  if (_selectedProfession != null) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('Profession: $_selectedProfession'),
                      onDeleted: () {
                        setState(() {
                          _selectedProfession = null;
                        });
                      },
                    ),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedArea = null;
                        _selectedProfession = null;
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),

          // Members List
          Expanded(
            child: membersState.isLoading
                ? FullScreenLoader(message: l10n.loading)
                : filteredMembers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No members found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (!isAuthenticated)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Login to view member directory',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await membersController.refreshMembers();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(DesignTokens.spacingM),
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            return _buildMemberCard(
                                context, member, isAuthenticated, index);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
      BuildContext context, UserModel member, bool isAuthenticated, int index) {
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedCard(
      index: index,
      backgroundColor: member.isVerified ? null : theme.cardColor,
      onTap: !isAuthenticated
          ? null
          : () {
              if (mounted) {
                Navigator.of(context).push(
                  PageTransitions.fadeSlideRoute(
                    MemberDetailScreen(member: member),
                  ),
                );
              }
            },
      child: Row(
        children: [
          // Profile Image with Verified Badge - Redesigned
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: member.isVerified
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryOrange.withValues(alpha: 0.2),
                            AppColors.primaryOrangeLight.withValues(alpha: 0.1),
                          ],
                        )
                      : null,
                  border: Border.all(
                    color: member.isVerified
                        ? AppColors.primaryOrange.withValues(alpha: 0.4)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.borderLight),
                    width: member.isVerified ? 2.5 : 2,
                  ),
                  boxShadow: member.isVerified
                      ? [
                          BoxShadow(
                            color:
                                AppColors.primaryOrange.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : AppColors.shadowLight,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.transparent,
                  backgroundImage: member.profileImageUrl != null
                      ? NetworkImage(member.profileImageUrl!)
                      : null,
                  child: member.profileImageUrl == null
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange.withValues(alpha: 0.15),
                                AppColors.primaryOrangeLight
                                    .withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : 'M',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeH4,
                                color: AppColors.primaryOrange,
                                fontWeight: DesignTokens.fontWeightBold,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              // Verified Badge
              if (member.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: DesignTokens.spacingL),
          // Member Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with Verified Indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _buildMemberNameWithGotra(member, l10n),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXXL,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: theme.textTheme.bodyLarge?.color ??
                              AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (member.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              DesignTokens.successColor.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: DesignTokens.successColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              l10n.verifiedMember,
                              style: TextStyle(
                                fontSize: 10,
                                color: DesignTokens.successColor,
                                fontWeight: DesignTokens.fontWeightSemiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingS),
                // House ID and Samaj ID Row
                if (member.houseId != null || member.samajId != null)
                  Wrap(
                    spacing: DesignTokens.spacingS,
                    runSpacing: DesignTokens.spacingXS,
                    children: [
                      if (member.houseId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.1),
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusS),
                            border: Border.all(
                              color: DesignTokens.primaryOrange
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home,
                                size: 14,
                                color: AppColors.primaryOrange,
                              ),
                              const SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                '${l10n.houseId}: ${member.houseId}',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeS,
                                  color: AppColors.primaryOrange,
                                  fontWeight: DesignTokens.fontWeightSemiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (member.samajId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.1),
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusS),
                            border: Border.all(
                              color: DesignTokens.primaryOrange
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.badge,
                                size: 14,
                                color: AppColors.primaryOrange,
                              ),
                              const SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'ID: ${member.samajId}',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeS,
                                  color: AppColors.primaryOrange,
                                  fontWeight: DesignTokens.fontWeightSemiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                if (member.houseId != null || member.samajId != null)
                  const SizedBox(height: DesignTokens.spacingS),
                // Area and Profession Row
                Wrap(
                  spacing: DesignTokens.spacingS,
                  runSpacing: DesignTokens.spacingXS,
                  children: [
                    if (member.area != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.grey100,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color ??
                                  AppColors.textSecondary,
                            ),
                            const SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              member.area!,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: theme.textTheme.bodySmall?.color ??
                                    AppColors.textSecondary,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (member.profession != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.grey100,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color ??
                                  AppColors.textSecondary,
                            ),
                            const SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              member.profession!,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: theme.textTheme.bodySmall?.color ??
                                    AppColors.textSecondary,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (member.phone.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.grey100,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color ??
                                  AppColors.textSecondary,
                            ),
                            const SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              member.phone,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: theme.textTheme.bodySmall?.color ??
                                    AppColors.textSecondary,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Call Button (only for members, not guests)
          if (isAuthenticated) ...[
            const SizedBox(width: DesignTokens.spacingS),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DesignTokens.primaryOrange,
                    DesignTokens.primaryOrangeDark,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _makePhoneCall(member.phone),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingM),
                    child: Icon(
                      Icons.phone,
                      color: AppColors.textOnPrimary,
                      size: DesignTokens.iconSizeM,
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(width: DesignTokens.spacingS),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock,
                color:
                    theme.textTheme.bodySmall?.color ?? AppColors.textSecondary,
                size: DesignTokens.iconSizeM,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildMemberNameWithGotra(UserModel member, AppLocalizations l10n) {
    final gotra = member.additionalInfo?['gotra'] as String?;
    if (gotra != null && gotra.isNotEmpty) {
      return '${l10n.shree} ${member.name} $gotra';
    }
    return '${l10n.shree} ${member.name}';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make call to $phoneNumber')),
      );
    }
  }
}
