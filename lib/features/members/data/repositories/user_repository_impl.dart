import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';
import '../repositories/user_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/app_logger.dart';

/// User repository implementation using Firebase
/// Implements UserRepository interface
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? _getFirestore(),
        _auth = auth ?? _getAuth();

  static FirebaseFirestore _getFirestore() {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseFirestore.instance;
  }

  static FirebaseAuth _getAuth() {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseAuth.instance;
  }

  @override
  Future<({Failure? failure, UserModel? data})> getUserById(
    String userId,
  ) async {
    try {
      AppLogger.debug('Getting user by ID: $userId');
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!, doc.id);
        AppLogger.debug('User retrieved successfully: $userId');
        return (failure: null, data: user);
      }
      AppLogger.warning('User not found: $userId');
      return (
        failure: const NotFoundFailure(message: 'User not found'),
        data: null,
      );
    } catch (e) {
      AppLogger.error('Failed to get user: $userId', e);
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, UserModel? data})> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return (
          failure: const NotFoundFailure(message: 'No user logged in'),
          data: null,
        );
      }
      return await getUserById(currentUser.uid);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, List<UserModel>? data})> getAllMembers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final members = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
      return (failure: null, data: members);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, List<UserModel>? data})> getMembersPaginated({
    String? lastDocumentId,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('users').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final members = snapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      return (failure: null, data: members);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, UserModel? data})> createUserFromPhone({
    required String uid,
    required String phoneNumber,
  }) async {
    try {
      final userData = {
        'name': 'User', // Default name, can be updated later
        'email': '',
        'phone': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'isActive': true,
        'role': 'member',
      };

      await _firestore.collection('users').doc(uid).set(userData);

      // Return the created user
      return await getUserById(uid);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, UserModel? data})> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
      // Return updated user
      return await getUserById(userId);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, List<UserModel>? data})> searchMembers(
    String query,
  ) async {
    try {
      final queryLower = query.toLowerCase();
      final snapshot = await _firestore.collection('users').get();
      final allMembers = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      // Filter members by search query
      final filtered = allMembers.where((member) {
        return member.name.toLowerCase().contains(queryLower) ||
            member.email.toLowerCase().contains(queryLower) ||
            member.phone.contains(query) ||
            (member.samajId?.toLowerCase().contains(queryLower) ?? false);
      }).toList();

      return (failure: null, data: filtered);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, List<UserModel>? data})> getMembersByRole(
    String role,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();
      final members = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
      return (failure: null, data: members);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }
}
