import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/membership_card.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../providers/members_provider.dart';
import '../../../auth/providers/auth_provider.dart';
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
  bool _isSearchActive = false;

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

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
      }
    });
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

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memberDirectory),
        centerTitle: true,
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
                  hintText: 'Search by name, samaj ID, area, profession...',
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
            child: ResponsivePage(
              useSafeArea: false,
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
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
