import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/user_model.dart';
import '../../../core/repositories/repository_providers.dart';

// Members controller provider
final membersControllerProvider =
    NotifierProvider<MembersController, MembersState>(() {
  return MembersController();
});

// Members state class
class MembersState {
  final bool isLoading;
  final String? error;
  final List<UserModel> members;
  final bool hasMore;
  final String? lastDocumentId;
  final String? searchQuery;
  final bool showVerifiedOnly;
  final String? locationFilter;
  final String? ageRangeFilter;

  const MembersState({
    this.isLoading = false,
    this.error,
    this.members = const [],
    this.hasMore = true,
    this.lastDocumentId,
    this.searchQuery,
    this.showVerifiedOnly = false,
    this.locationFilter,
    this.ageRangeFilter,
  });

  MembersState copyWith({
    bool? isLoading,
    String? error,
    List<UserModel>? members,
    bool? hasMore,
    String? lastDocumentId,
    String? searchQuery,
    bool? showVerifiedOnly,
    String? locationFilter,
    String? ageRangeFilter,
  }) {
    return MembersState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      members: members ?? this.members,
      hasMore: hasMore ?? this.hasMore,
      lastDocumentId: lastDocumentId ?? this.lastDocumentId,
      searchQuery: searchQuery ?? this.searchQuery,
      showVerifiedOnly: showVerifiedOnly ?? this.showVerifiedOnly,
      locationFilter: locationFilter ?? this.locationFilter,
      ageRangeFilter: ageRangeFilter ?? this.ageRangeFilter,
    );
  }
}

// Members controller
class MembersController extends Notifier<MembersState> {
  @override
  MembersState build() {
    return const MembersState();
  }

  // Load all members
  Future<void> loadMembers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Use repository pattern for better testability
      final repository = ref.read(userRepositoryProvider);
      final result = await repository.getAllMembers();

      if (result.failure != null) {
        state = state.copyWith(
          isLoading: false,
          error: result.failure!.message,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        members: result.data ?? [],
        hasMore: false, // All members loaded at once
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load members with pagination
  Future<void> loadMoreMembers() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Use repository pattern for better testability
      final repository = ref.read(userRepositoryProvider);
      final result = await repository.getMembersPaginated(
        lastDocumentId: state.lastDocumentId,
        limit: 20,
      );

      if (result.failure != null) {
        state = state.copyWith(
          isLoading: false,
          error: result.failure!.message,
        );
        return;
      }

      final newMembers = result.data ?? [];

      if (newMembers.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        members: [...state.members, ...newMembers],
        lastDocumentId: newMembers.last.id,
        hasMore: newMembers.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Search members
  void searchMembers(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Toggle verified filter
  void toggleVerifiedFilter() {
    state = state.copyWith(showVerifiedOnly: !state.showVerifiedOnly);
  }

  // Set location filter
  void setLocationFilter(String? location) {
    state = state.copyWith(locationFilter: location);
  }

  // Set age range filter
  void setAgeRangeFilter(String? ageRange) {
    state = state.copyWith(ageRangeFilter: ageRange);
  }

  // Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      showVerifiedOnly: false,
      locationFilter: null,
      ageRangeFilter: null,
    );
  }

  // Get filtered members
  List<UserModel> getFilteredMembers() {
    var filteredMembers = state.members;

    // Apply search filter
    if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      final query = state.searchQuery!.toLowerCase();
      filteredMembers = filteredMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query) ||
            (member.samajId?.toLowerCase().contains(query) ?? false) ||
            member.phone.contains(query);
      }).toList();
    }

    // Apply verified filter
    if (state.showVerifiedOnly) {
      filteredMembers =
          filteredMembers.where((member) => member.isVerified).toList();
    }

    // Apply location filter
    if (state.locationFilter != null && state.locationFilter!.isNotEmpty) {
      filteredMembers = filteredMembers.where((member) {
        final additionalInfo = member.additionalInfo;
        if (additionalInfo == null) return false;
        final memberLocation = additionalInfo['location'] as String?;
        return memberLocation
                ?.toLowerCase()
                .contains(state.locationFilter!.toLowerCase()) ??
            false;
      }).toList();
    }

    // Apply age range filter
    if (state.ageRangeFilter != null && state.ageRangeFilter!.isNotEmpty) {
      final ageRange = state.ageRangeFilter!;
      final parts = ageRange.split('-');
      if (parts.length == 2) {
        final minAge = int.tryParse(parts[0]);
        final maxAge = int.tryParse(parts[1]);

        if (minAge != null && maxAge != null) {
          filteredMembers = filteredMembers.where((member) {
            final additionalInfo = member.additionalInfo;
            if (additionalInfo == null) return false;
            final birthYear = additionalInfo['birthYear'] as int?;
            if (birthYear == null) return false;

            final currentYear = DateTime.now().year;
            final age = currentYear - birthYear;
            return age >= minAge && age <= maxAge;
          }).toList();
        }
      }
    }

    return filteredMembers;
  }

  // Get verified members
  List<UserModel> get verifiedMembers {
    return state.members.where((member) => member.isVerified).toList();
  }

  // Get unverified members
  List<UserModel> get unverifiedMembers {
    return state.members.where((member) => !member.isVerified).toList();
  }

  // Get members by location
  List<UserModel> getMembersByLocation(String location) {
    return state.members.where((member) {
      final additionalInfo = member.additionalInfo;
      if (additionalInfo == null) return false;
      final memberLocation = additionalInfo['location'] as String?;
      return memberLocation?.toLowerCase().contains(location.toLowerCase()) ??
          false;
    }).toList();
  }

  // Get members by age range
  List<UserModel> getMembersByAgeRange(int minAge, int maxAge) {
    return state.members.where((member) {
      final additionalInfo = member.additionalInfo;
      if (additionalInfo == null) return false;
      final birthYear = additionalInfo['birthYear'] as int?;
      if (birthYear == null) return false;

      final currentYear = DateTime.now().year;
      final age = currentYear - birthYear;
      return age >= minAge && age <= maxAge;
    }).toList();
  }

  // Get recently joined members (last 30 days)
  List<UserModel> get recentlyJoinedMembers {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return state.members
        .where((member) => member.createdAt.isAfter(monthAgo))
        .toList();
  }

  // Get members with profile images
  List<UserModel> get membersWithProfileImages {
    return state.members
        .where((member) =>
            member.profileImageUrl != null &&
            member.profileImageUrl!.isNotEmpty)
        .toList();
  }

  // Get members without profile images
  List<UserModel> get membersWithoutProfileImages {
    return state.members
        .where((member) =>
            member.profileImageUrl == null || member.profileImageUrl!.isEmpty)
        .toList();
  }

  // Sort members by name
  List<UserModel> getMembersSortedByName() {
    final sortedMembers = List<UserModel>.from(state.members);
    sortedMembers.sort((a, b) => a.name.compareTo(b.name));
    return sortedMembers;
  }

  // Sort members by join date (newest first)
  List<UserModel> getMembersSortedByJoinDate() {
    final sortedMembers = List<UserModel>.from(state.members);
    sortedMembers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedMembers;
  }

  // Sort members by verification status
  List<UserModel> getMembersSortedByVerification() {
    final sortedMembers = List<UserModel>.from(state.members);
    sortedMembers.sort((a, b) {
      if (a.isVerified && !b.isVerified) return -1;
      if (!a.isVerified && b.isVerified) return 1;
      return 0;
    });
    return sortedMembers;
  }

  // Refresh members
  Future<void> refreshMembers() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      members: [],
      hasMore: true,
      lastDocumentId: null,
    );
    await loadMembers();
  }

  // Add member to local state
  void addMember(UserModel member) {
    final updatedMembers = [...state.members, member];
    state = state.copyWith(members: updatedMembers);
  }

  // Update member in local state
  void updateMember(UserModel updatedMember) {
    final updatedMembers = state.members.map((member) {
      return member.id == updatedMember.id ? updatedMember : member;
    }).toList();
    state = state.copyWith(members: updatedMembers);
  }

  // Remove member from local state
  void removeMember(String memberId) {
    final updatedMembers =
        state.members.where((member) => member.id != memberId).toList();
    state = state.copyWith(members: updatedMembers);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
