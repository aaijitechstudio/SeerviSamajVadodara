import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/post_model.dart';
import '../repositories/post_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/app_logger.dart';

/// Post repository implementation using Firebase
class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore;

  PostRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? _getFirestore();

  static FirebaseFirestore _getFirestore() {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseFirestore.instance;
  }

  @override
  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<({Failure? failure, List<PostModel>? data})> getPostsPaginated({
    String? lastDocumentId,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('posts').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final posts = snapshot.docs
          .map((doc) =>
              PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      return (failure: null, data: posts);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, PostModel? data})> createPost(
    PostModel post,
  ) async {
    try {
      final docRef = await _firestore.collection('posts').add(post.toMap());
      // Return created post with ID
      final createdPost = post.copyWith(id: docRef.id);
      return (failure: null, data: createdPost);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, bool? success})> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return (failure: null, success: true);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, success: null);
    }
  }

  @override
  Future<({Failure? failure, PostModel? data})> updatePostLikes({
    required String postId,
    required List<String> likedBy,
    required int likesCount,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likedBy': likedBy,
        'likesCount': likesCount,
      });
      // Return updated post
      return await getPostById(postId);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, PostModel? data})> getPostById(
      String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists && doc.data() != null) {
        final post = PostModel.fromMap(doc.data()!, doc.id);
        return (failure: null, data: post);
      }
      return (
        failure: const NotFoundFailure(message: 'Post not found'),
        data: null,
      );
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, List<PostModel>? data})> getPostsByAuthor(
    String authorId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: authorId)
          .orderBy('createdAt', descending: true)
          .get();
      final posts = snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data(), doc.id))
          .toList();
      return (failure: null, data: posts);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }
}
