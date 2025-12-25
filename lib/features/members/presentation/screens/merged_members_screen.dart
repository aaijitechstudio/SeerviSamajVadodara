import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/membership_card.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../providers/members_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../committee/data/committee_data.dart';
import '../../../committee/domain/models/committee_model.dart';
import 'member_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isMembersSearchActive = false;
  bool _isCommitteeSearchActive = false;
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
    setState(() {
      _isMembersSearchActive = !_isMembersSearchActive;
      if (!_isMembersSearchActive) {
        _membersSearchController.clear();
      }
    });
  }

  void _toggleCommitteeSearch() {
    setState(() {
      _isCommitteeSearchActive = !_isCommitteeSearchActive;
      if (!_isCommitteeSearchActive) {
        _committeeSearchController.clear();
      }
    });
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.members),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _tabController.index == 0
                  ? (_isMembersSearchActive ? Icons.close : Icons.search)
                  : (_isCommitteeSearchActive ? Icons.close : Icons.search),
            ),
            tooltip: _tabController.index == 0
                ? (_isMembersSearchActive ? 'Close search' : 'Search')
                : (_isCommitteeSearchActive ? 'Close search' : 'Search'),
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
            setState(() {
              // Reset search states when switching tabs
              if (index == 0) {
                _isCommitteeSearchActive = false;
                _committeeSearchController.clear();
              } else {
                _isMembersSearchActive = false;
                _membersSearchController.clear();
              }
            });
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar for Members Tab
          if (_tabController.index == 0 && _isMembersSearchActive)
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
          if (_tabController.index == 1 && _isCommitteeSearchActive)
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

    // Apply search filter if active
    List<CommitteeModel> filteredMembers = allMembers;
    if (_isCommitteeSearchActive && searchQuery.isNotEmpty) {
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
              color: DesignTokens.grey400,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.noCommitteeMembersYet,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                color: DesignTokens.grey600,
              ),
            ),
          ],
        ),
      );
    }

    // If search is active, show filtered results without sections
    if (_isCommitteeSearchActive && searchQuery.isNotEmpty) {
      if (filteredMembers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: DesignTokens.iconSizeXL,
                color: DesignTokens.grey400,
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                'No members found',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  color: DesignTokens.grey600,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                'Try a different search term',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  color: DesignTokens.grey500,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingM,
          ),
          children: filteredMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            final locale = Localizations.localeOf(context);
            return MembershipCard(
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
            );
          }).toList(),
        ),
      );
    }

    // Normal view with sections when search is not active or search is empty
    final executiveCommittee = CommitteeData.executiveCommittee;
    final executiveMembers = CommitteeData.executiveMembers;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingM,
        ),
        children: [
          // Executive Committee Section
          if (executiveCommittee.isNotEmpty) ...[
            _buildSectionHeader(
              l10n.executiveCommittee,
              l10n.executiveCommittee,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            ...executiveCommittee.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              final locale = Localizations.localeOf(context);
              return MembershipCard(
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
              );
            }),
            const SizedBox(height: DesignTokens.spacingL),
          ],

          // Executive Members Section
          if (executiveMembers.isNotEmpty) ...[
            _buildSectionHeader(
              l10n.executiveMembers,
              l10n.executiveMembers,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            ...executiveMembers.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              final locale = Localizations.localeOf(context);
              return MembershipCard(
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
              );
            }),
          ],
        ],
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
            DesignTokens.primaryOrange.withValues(alpha: 0.1),
            DesignTokens.primaryOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: DesignTokens.primaryOrange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.group,
            color: DesignTokens.primaryOrange,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: Text(
              getLocalizedTitle(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeL,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
