import '../../../../shared/models/post_model.dart';
import '../../../../shared/models/comment_model.dart';
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

  /// Get posts by category
  Future<({Failure? failure, List<PostModel>? data})> getPostsByCategory(
    PostCategory category, {
    String? lastDocumentId,
    int limit = 20,
  });

  /// Get comments for a post
  Future<({Failure? failure, List<CommentModel>? data})> getComments(
    String postId, {
    String? lastDocumentId,
    int limit = 50,
  });

  /// Add a comment to a post
  Future<({Failure? failure, CommentModel? data})> addComment(
    CommentModel comment,
  );

  /// Delete a comment
  Future<({Failure? failure, bool? success})> deleteComment(
    String postId,
    String commentId,
  );

  /// Update post comment count
  Future<({Failure? failure, bool? success})> updatePostCommentCount(
    String postId,
    int commentsCount,
  );
}
