import '../../domain/models/user_model.dart';
import '../../../../core/errors/failure.dart';

/// User repository interface
/// Defines all user-related data operations
abstract class UserRepository {
  /// Get user by ID
  Future<({Failure? failure, UserModel? data})> getUserById(String userId);

  /// Get current authenticated user
  Future<({Failure? failure, UserModel? data})> getCurrentUser();

  /// Get all members
  Future<({Failure? failure, List<UserModel>? data})> getAllMembers();

  /// Get members with pagination
  Future<({Failure? failure, List<UserModel>? data})> getMembersPaginated({
    String? lastDocumentId,
    int limit = 20,
  });

  /// Create user from phone authentication
  Future<({Failure? failure, UserModel? data})> createUserFromPhone({
    required String uid,
    required String phoneNumber,
  });

  /// Update user data
  Future<({Failure? failure, UserModel? data})> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Search members by query
  Future<({Failure? failure, List<UserModel>? data})> searchMembers(
    String query,
  );

  /// Get members by role
  Future<({Failure? failure, List<UserModel>? data})> getMembersByRole(
    String role,
  );
}
