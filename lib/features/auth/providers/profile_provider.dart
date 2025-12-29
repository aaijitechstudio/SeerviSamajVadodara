import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../members/domain/models/user_model.dart';
import '../../../shared/data/firebase_service.dart';
import '../../../shared/data/samaj_id_generator.dart';

// Profile controller provider
final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(() {
  return ProfileController();
});

// Members list provider (auto-disposing for better memory management)
final membersProvider = FutureProvider.autoDispose<List<UserModel>>((ref) async {
  return await FirebaseService.getAllMembers();
});

// Profile state class
class ProfileState {
  final bool isLoading;
  final String? error;
  final UserModel? currentUser;
  final List<UserModel> members;
  final String? searchQuery;
  final bool showVerifiedOnly;

  const ProfileState({
    this.isLoading = false,
    this.error,
    this.currentUser,
    this.members = const [],
    this.searchQuery,
    this.showVerifiedOnly = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    UserModel? currentUser,
    List<UserModel>? members,
    String? searchQuery,
    bool? showVerifiedOnly,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentUser: currentUser ?? this.currentUser,
      members: members ?? this.members,
      searchQuery: searchQuery ?? this.searchQuery,
      showVerifiedOnly: showVerifiedOnly ?? this.showVerifiedOnly,
    );
  }
}

// Profile controller
class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  // Load current user profile
  Future<void> loadCurrentUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await FirebaseService.getUserData(userId);
      state = state.copyWith(
        isLoading: false,
        currentUser: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load all members
  Future<void> loadMembers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final members = await FirebaseService.getAllMembers();
      state = state.copyWith(
        isLoading: false,
        members: members,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImageUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    if (state.currentUser == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }
      if (additionalInfo != null) updateData['additionalInfo'] = additionalInfo;

      await FirebaseService.updateUserData(state.currentUser!.id, updateData);

      final updatedUser =
          await FirebaseService.getUserData(state.currentUser!.id);
      state = state.copyWith(
        isLoading: false,
        currentUser: updatedUser,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Generate Samaj ID
  Future<bool> generateSamajId() async {
    if (state.currentUser == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final samajId = SamajIdGenerator.generateSamajId();

      await FirebaseService.updateUserData(state.currentUser!.id, {
        'samajId': samajId,
        'isVerified': false, // New ID needs verification
      });

      final updatedUser =
          await FirebaseService.getUserData(state.currentUser!.id);
      state = state.copyWith(
        isLoading: false,
        currentUser: updatedUser,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
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

  // Clear search
  void clearSearch() {
    state = state.copyWith(searchQuery: null);
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

  // Get members by location (if available in additionalInfo)
  List<UserModel> getMembersByLocation(String location) {
    return state.members.where((member) {
      final additionalInfo = member.additionalInfo;
      if (additionalInfo == null) return false;
      final memberLocation = additionalInfo['location'] as String?;
      return memberLocation?.toLowerCase().contains(location.toLowerCase()) ??
          false;
    }).toList();
  }

  // Get members by age range (if available in additionalInfo)
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

  // Set current user
  void setCurrentUser(UserModel user) {
    state = state.copyWith(currentUser: user);
  }
}
