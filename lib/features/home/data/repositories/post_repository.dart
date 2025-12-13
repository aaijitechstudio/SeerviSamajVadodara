import '../../../../shared/models/post_model.dart';
import '../../../../core/errors/failure.dart';

/// Post repository interface
/// Defines all post-related data operations
abstract class PostRepository {
  /// Get all posts as a stream
  Stream<List<PostModel>> getPostsStream();

  /// Get posts with pagination
  Future<({Failure? failure, List<PostModel>? data})> getPostsPaginated({
    String? lastDocumentId,
    int limit = 20,
  });

  /// Create a new post
  Future<({Failure? failure, PostModel? data})> createPost(PostModel post);

  /// Delete a post
  Future<({Failure? failure, bool? success})> deletePost(String postId);

  /// Update post likes
  Future<({Failure? failure, PostModel? data})> updatePostLikes({
    required String postId,
    required List<String> likedBy,
    required int likesCount,
  });

  /// Get post by ID
  Future<({Failure? failure, PostModel? data})> getPostById(String postId);

  /// Get posts by author
  Future<({Failure? failure, List<PostModel>? data})> getPostsByAuthor(
    String authorId,
  );
}
