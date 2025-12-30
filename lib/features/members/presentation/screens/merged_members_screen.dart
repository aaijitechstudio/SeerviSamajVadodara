import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/membership_card.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/ui_state_provider.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../providers/members_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../committee/data/committee_data.dart';
import '../../../committee/domain/models/committee_model.dart';
import 'member_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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

class MergedMembersScreen extends ConsumerStatefulWidget {
  const MergedMembersScreen({super.key});

  @override
  ConsumerState<MergedMembersScreen> createState() =>
      _MergedMembersScreenState();
}

class _MergedMembersScreenState extends ConsumerState<MergedMembersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _membersSearchController =
      TextEditingController();
  final TextEditingController _committeeSearchController =
      TextEditingController();
  String? _selectedArea;
  String? _selectedProfession;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(membersControllerProvider.notifier).loadMembers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _membersSearchController.dispose();
    _committeeSearchController.dispose();
    super.dispose();
  }

  void _toggleMembersSearch() {
    final isSearchActive = ref.read(membersSearchActiveProvider.notifier);
    isSearchActive.state = !isSearchActive.state;
    if (!isSearchActive.state) {
      _membersSearchController.clear();
    }
  }

  void _toggleCommitteeSearch() {
    final isSearchActive = ref.read(committeeSearchActiveProvider.notifier);
    isSearchActive.state = !isSearchActive.state;
    if (!isSearchActive.state) {
      _committeeSearchController.clear();
    }
  }

  List<CommitteeModel> _filterCommitteeMembers(
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final isAuthenticated = authState.user != null;
    final membersState = ref.watch(membersControllerProvider);
    final isMembersSearchActive = ref.watch(membersSearchActiveProvider);
    final isCommitteeSearchActive = ref.watch(committeeSearchActiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.members),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _tabController.index == 0
                  ? (isMembersSearchActive ? Icons.close : Icons.search)
                  : (isCommitteeSearchActive ? Icons.close : Icons.search),
            ),
            tooltip: _tabController.index == 0
                ? (isMembersSearchActive ? 'Close search' : 'Search')
                : (isCommitteeSearchActive ? 'Close search' : 'Search'),
            onPressed: _tabController.index == 0
                ? _toggleMembersSearch
                : _toggleCommitteeSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.members),
            Tab(text: l10n.committeeMembers),
          ],
          onTap: (index) {
            // Reset search states when switching tabs
            if (index == 0) {
              ref.read(committeeSearchActiveProvider.notifier).state = false;
              _committeeSearchController.clear();
            } else {
              ref.read(membersSearchActiveProvider.notifier).state = false;
              _membersSearchController.clear();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar for Members Tab
          if (_tabController.index == 0 && isMembersSearchActive)
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              child: TextField(
                controller: _membersSearchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name, samaj ID, area, profession...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _membersSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _membersSearchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

          // Search Bar for Committee Tab
          if (_tabController.index == 1 && isCommitteeSearchActive)
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              child: TextField(
                controller: _committeeSearchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name, position, location, gotra...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _committeeSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _committeeSearchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

          // Active Filters for Members Tab
          if (_tabController.index == 0 &&
              (_selectedArea != null || _selectedProfession != null))
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

          // Tab Views
          Expanded(
            child: ResponsivePage(
              useSafeArea: false,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Members Tab
                  _buildMembersTab(isAuthenticated, membersState, l10n),
                  // Committee Members Tab
                  _buildCommitteeTab(l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(
    bool isAuthenticated,
    dynamic membersState,
    AppLocalizations l10n,
  ) {
    final membersController = ref.read(membersControllerProvider.notifier);

    // Apply filters
    var filteredMembers = membersState.members;

    if (_membersSearchController.text.isNotEmpty) {
      final query = _membersSearchController.text.toLowerCase();
      filteredMembers = filteredMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            (member.samajId?.toLowerCase().contains(query) ?? false) ||
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

    return membersState.isLoading
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingM,
                    vertical: DesignTokens.spacingM,
                  ),
                  itemCount: filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = filteredMembers[index];
                    return MembershipCard(
                      name: member.name,
                      samajId: member.samajId,
                      role: l10n.members,
                      location: member.area ?? member.address,
                      profileImageUrl: member.profileImageUrl,
                      gotra: member.additionalInfo?['gotra'] as String?,
                      isVerified: member.isVerified,
                      isCommitteeMember: false,
                      index: index,
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
                    );
                  },
                ),
              );
  }

  Widget _buildCommitteeTab(AppLocalizations l10n) {
    final allMembers = CommitteeData.allMembers;
    final searchQuery = _committeeSearchController.text;
    final isCommitteeSearchActive = ref.watch(committeeSearchActiveProvider);

    // Apply search filter if active
    List<CommitteeModel> filteredMembers = allMembers;
    if (isCommitteeSearchActive && searchQuery.isNotEmpty) {
      filteredMembers = _filterCommitteeMembers(allMembers, searchQuery);
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
    if (isCommitteeSearchActive && searchQuery.isNotEmpty) {
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
            final locale = Localizations.localeOf(context);
            return RepaintBoundary(
              child: MembershipCard(
                name: member.name,
                samajId: null,
                role: member.getLocalizedPosition(locale),
                location: member.location ?? member.area,
                profileImageUrl: member.imageUrl,
                gotra: member.gotra,
                isVerified: true,
                isCommitteeMember: true,
                index: index,
                onTap: member.phone.isNotEmpty
                    ? () => _makePhoneCall(member.phone)
                    : null,
              ),
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
            final locale = Localizations.localeOf(context);
            return RepaintBoundary(
              child: MembershipCard(
                name: member.name,
                samajId: null,
                role: member.getLocalizedPosition(locale),
                location: member.location ?? member.area,
                profileImageUrl: member.imageUrl,
                gotra: member.gotra,
                isVerified: true,
                isCommitteeMember: true,
                index: index,
                onTap: member.phone.isNotEmpty
                    ? () => _makePhoneCall(member.phone)
                    : null,
              ),
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
}
