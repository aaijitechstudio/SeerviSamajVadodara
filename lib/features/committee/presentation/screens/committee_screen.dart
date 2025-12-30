import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/constants/design_tokens.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/membership_card.dart';
import '../../../../../core/providers/ui_state_provider.dart';
import '../../../../../core/widgets/responsive_page.dart';
import '../../data/committee_data.dart';
import '../../domain/models/committee_model.dart';
import '../providers/committee_image_url_provider.dart';

// Helper class for flattened list items
class _SectionItem {
  final String? titleHi;
  final String? titleEn;
  final CommitteeModel? member;
  final double? spacerHeight;
  final bool isHeader;
  final bool isSpacer;

  _SectionItem._({
    this.titleHi,
    this.titleEn,
    this.member,
    this.spacerHeight,
    required this.isHeader,
    required this.isSpacer,
  });

  factory _SectionItem.header(String titleHi, String titleEn) {
    return _SectionItem._(
      titleHi: titleHi,
      titleEn: titleEn,
      isHeader: true,
      isSpacer: false,
    );
  }

  factory _SectionItem.member(CommitteeModel member) {
    return _SectionItem._(
      member: member,
      isHeader: false,
      isSpacer: false,
    );
  }

  factory _SectionItem.spacer(double height) {
    return _SectionItem._(
      spacerHeight: height,
      isHeader: false,
      isSpacer: true,
    );
  }
}

class CommitteeScreen extends ConsumerStatefulWidget {
  const CommitteeScreen({super.key});

  @override
  ConsumerState<CommitteeScreen> createState() => _CommitteeScreenState();
}

class _CommitteeScreenState extends ConsumerState<CommitteeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isSearchActive = ref.read(searchActiveProvider.notifier);
    isSearchActive.state = !isSearchActive.state;
    if (!isSearchActive.state) {
      _searchController.clear();
    }
  }

  List<CommitteeModel> _filterMembers(
    List<CommitteeModel> members,
    String query,
  ) {
    if (query.isEmpty) return members;

    final lowerQuery = query.toLowerCase();
    return members.where((member) {
      return member.name.toLowerCase().contains(lowerQuery) ||
          (member.position.toLowerCase().contains(lowerQuery)) ||
          (member.positionEn.toLowerCase().contains(lowerQuery)) ||
          (member.location?.toLowerCase().contains(lowerQuery) ?? false) ||
          (member.area?.toLowerCase().contains(lowerQuery) ?? false) ||
          (member.gotra?.toLowerCase().contains(lowerQuery) ?? false) ||
          (member.fatherName?.toLowerCase().contains(lowerQuery) ?? false) ||
          member.phone.contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSearchActive = ref.watch(searchActiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.committeeMembers),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSearchActive ? Icons.close : Icons.search),
            tooltip: isSearchActive ? 'Close search' : 'Search',
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: Column(
          children: [
          // Search Bar
          if (isSearchActive)
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name, position, location, gotra...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                ),
                onChanged: (_) {
                  // Trigger rebuild for clear button visibility
                  setState(() {});
                },
              ),
            ),
          // Committee List
          Expanded(
            child: _buildCommitteeList(context, l10n),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(CommitteeModel member, int index) {
    return _CommitteeMemberCard(
      member: member,
      index: index,
      onTap: member.phone.isNotEmpty ? () => _makePhoneCall(member.phone) : null,
    );
  }

  Widget _buildCommitteeList(BuildContext context, AppLocalizations l10n) {
    final allMembers = CommitteeData.allMembers;
    final searchQuery = _searchController.text;
    final isSearchActive = ref.watch(searchActiveProvider);

    // Apply search filter if active
    List<CommitteeModel> filteredMembers = allMembers;
    if (isSearchActive && searchQuery.isNotEmpty) {
      filteredMembers = _filterMembers(allMembers, searchQuery);
    }

    if (allMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: DesignTokens.iconSizeXL,
              color: AppColors.grey400,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.noCommitteeMembersYet,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    // If search is active, show filtered results without sections
    if (isSearchActive && searchQuery.isNotEmpty) {
      if (filteredMembers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: DesignTokens.iconSizeXL,
                color: AppColors.grey400,
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                'No members found',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                'Try a different search term',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          // Refresh committee data (for future dynamic data)
          // No state to refresh for static data
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingM,
          ),
          itemCount: filteredMembers.length,
          itemBuilder: (context, index) {
            final member = filteredMembers[index];
            return RepaintBoundary(
              child: _buildMemberCard(member, index),
            );
          },
        ),
      );
    }

    // Normal view with sections when search is not active or search is empty
    final executiveCommittee = CommitteeData.executiveCommittee;
    final executiveMembers = CommitteeData.executiveMembers;

    // Build flattened list for ListView.builder
    final List<_SectionItem> items = [];
    if (executiveCommittee.isNotEmpty) {
      items.add(_SectionItem.header(l10n.executiveCommittee, l10n.executiveCommittee));
      for (var member in executiveCommittee) {
        items.add(_SectionItem.member(member));
      }
      items.add(_SectionItem.spacer(DesignTokens.spacingL));
    }
    if (executiveMembers.isNotEmpty) {
      items.add(_SectionItem.header(l10n.executiveMembers, l10n.executiveMembers));
      for (var member in executiveMembers) {
        items.add(_SectionItem.member(member));
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh committee data (for future dynamic data)
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingM,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item.isHeader) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index > 0 ? DesignTokens.spacingM : 0,
              ),
              child: _buildSectionHeader(item.titleHi!, item.titleEn!),
            );
          } else if (item.isSpacer) {
            return SizedBox(height: item.spacerHeight);
          } else {
            final member = item.member!;
            return RepaintBoundary(
              child: _buildMemberCard(member, index),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(String titleHi, String titleEn) {
    final locale = Localizations.localeOf(context);

    // Get localized title based on current locale
    String getLocalizedTitle() {
      switch (locale.languageCode) {
        case 'hi':
          return titleHi;
        case 'gu':
          // For Gujarati, use Hindi for now (can be extended later)
          return titleHi;
        case 'en':
        default:
          return titleEn;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.1),
            AppColors.primaryOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.group,
            color: AppColors.primaryOrange,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: Text(
              getLocalizedTitle(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeL,
                fontWeight: DesignTokens.fontWeightBold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

class _CommitteeMemberCard extends ConsumerWidget {
  final CommitteeModel member;
  final int index;
  final VoidCallback? onTap;

  const _CommitteeMemberCard({
    required this.member,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);

    final directUrl = member.imageUrl;
    final storagePath = member.imageStoragePath;

    final resolvedUrl = (directUrl != null && directUrl.isNotEmpty)
        ? directUrl
        : (storagePath != null && storagePath.isNotEmpty)
            ? ref.watch(committeeImageUrlProvider(storagePath)).valueOrNull
            : null;

    return MembershipCard(
      name: member.name,
      samajId: null,
      role: member.getLocalizedPosition(locale),
      location: member.location ?? member.area,
      profileImageUrl: resolvedUrl,
      gotra: member.gotra,
      isVerified: true,
      isCommitteeMember: true,
      index: index,
      onTap: onTap,
    );
  }
}
