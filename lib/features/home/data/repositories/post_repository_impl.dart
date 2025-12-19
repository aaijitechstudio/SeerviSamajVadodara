import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../shared/models/comment_model.dart';
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
      final postData = post.toMap();
      AppLogger.debug('Creating post with data: $postData');

      final docRef = await _firestore.collection('posts').add(postData);
      AppLogger.debug('Post created with ID: ${docRef.id}');

      // Return created post with ID
      final createdPost = post.copyWith(id: docRef.id);
      return (failure: null, data: createdPost);
    } catch (e) {
      AppLogger.error('Failed to create post', e, StackTrace.current);
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

  @override
  Future<({Failure? failure, List<PostModel>? data})> getPostsByCategory(
    PostCategory category, {
    String? lastDocumentId,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .where('category', isEqualTo: category.toString().split('.').last)
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
  Future<({Failure? failure, List<CommentModel>? data})> getComments(
    String postId, {
    String? lastDocumentId,
    int limit = 50,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: false)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final comments = snapshot.docs
          .map((doc) =>
              CommentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      return (failure: null, data: comments);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, CommentModel? data})> addComment(
    CommentModel comment,
  ) async {
    try {
      final batch = _firestore.batch();

      // Add comment
      final commentRef = _firestore
          .collection('posts')
          .doc(comment.postId)
          .collection('comments')
          .doc();
      batch.set(commentRef, comment.copyWith(id: commentRef.id).toMap());

      // Update post comment count
      final postRef = _firestore.collection('posts').doc(comment.postId);
      final postDoc = await postRef.get();
      if (postDoc.exists) {
        final currentCount = postDoc.data()?['commentsCount'] ?? 0;
        batch.update(postRef, {'commentsCount': currentCount + 1});
      }

      await batch.commit();

      final createdComment = comment.copyWith(id: commentRef.id);
      return (failure: null, data: createdComment);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }

  @override
  Future<({Failure? failure, bool? success})> deleteComment(
    String postId,
    String commentId,
  ) async {
    try {
      final batch = _firestore.batch();

      // Soft delete comment
      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);
      batch.update(commentRef, {'isDeleted': true});

      // Update post comment count
      final postRef = _firestore.collection('posts').doc(postId);
      final postDoc = await postRef.get();
      if (postDoc.exists) {
        final currentCount = postDoc.data()?['commentsCount'] ?? 0;
        batch.update(postRef, {
          'commentsCount': (currentCount - 1).clamp(0, double.infinity).toInt()
        });
      }

      await batch.commit();
      return (failure: null, success: true);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, success: null);
    }
  }

  @override
  Future<({Failure? failure, bool? success})> updatePostCommentCount(
    String postId,
    int commentsCount,
  ) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': commentsCount,
      });
      return (failure: null, success: true);
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, success: null);
    }
  }
}
