import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/constants/design_tokens.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/membership_card.dart';
import '../../data/committee_data.dart';
import '../../domain/models/committee_model.dart';

class CommitteeScreen extends ConsumerStatefulWidget {
  const CommitteeScreen({super.key});

  @override
  ConsumerState<CommitteeScreen> createState() => _CommitteeScreenState();
}

class _CommitteeScreenState extends ConsumerState<CommitteeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
      }
    });
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

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.committeeMembers,
        showLogo: false,
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            tooltip: _isSearchActive ? 'Close search' : 'Search',
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_isSearchActive)
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
          // Committee List
          Expanded(
            child: _buildCommitteeList(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildCommitteeList(BuildContext context, AppLocalizations l10n) {
    final allMembers = CommitteeData.allMembers;
    final searchQuery = _searchController.text;

    // Apply search filter if active
    List<CommitteeModel> filteredMembers = allMembers;
    if (_isSearchActive && searchQuery.isNotEmpty) {
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
    if (_isSearchActive && searchQuery.isNotEmpty) {
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
          // Refresh committee data (for future dynamic data)
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
        // Refresh committee data (for future dynamic data)
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
