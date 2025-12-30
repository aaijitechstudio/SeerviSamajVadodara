import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/post_model.dart';
import '../../../shared/data/firebase_service.dart';
import '../../auth/providers/auth_provider.dart';

// Posts stream provider (auto-disposing for better memory management)
final postsStreamProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  return FirebaseService.getPosts();
});

// Post controller provider (auto-disposing for better memory management)
final postControllerProvider =
    NotifierProvider.autoDispose<PostController, PostState>(() {
  return PostController();
});

// Post state class
class PostState {
  final bool isLoading;
  final String? error;
  final List<PostModel> posts;
  final bool hasMore;
  final String? lastDocumentId;

  const PostState({
    this.isLoading = false,
    this.error,
    this.posts = const [],
    this.hasMore = true,
    this.lastDocumentId,
  });

  PostState copyWith({
    bool? isLoading,
    String? error,
    List<PostModel>? posts,
    bool? hasMore,
    String? lastDocumentId,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      lastDocumentId: lastDocumentId ?? this.lastDocumentId,
    );
  }
}

// Post controller
class PostController extends AutoDisposeNotifier<PostState> {
  @override
  PostState build() {
    return const PostState();
  }

  // Create a new post
  Future<bool> createPost({
    required String content,
    required PostType type,
    List<String>? imageUrls,
    List<String>? videoUrls,
    bool isAnnouncement = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get current user from auth provider
      final authState = ref.read(authControllerProvider);
      if (authState.user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return false;
      }

      final post = PostModel(
        id: '', // Will be set by Firebase
        authorId: authState.user!.id,
        authorName: authState.user!.name,
        authorProfileImage: authState.user!.profileImageUrl,
        content: content,
        type: type,
        imageUrls: imageUrls,
        videoUrls: videoUrls,
        createdAt: DateTime.now(),
        isAnnouncement: isAnnouncement,
      );

      await FirebaseService.createPost(post);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Delete a post
  Future<bool> deletePost(String postId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await FirebaseService.deletePost(postId);

      // Remove from local state
      final updatedPosts =
          state.posts.where((post) => post.id != postId).toList();
      state = state.copyWith(
        isLoading: false,
        posts: updatedPosts,
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

  // Like/Unlike a post
  Future<bool> toggleLike(String postId, String userId) async {
    try {
      final postIndex = state.posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return false;

      final post = state.posts[postIndex];
      final isLiked = post.likedBy.contains(userId);

      final updatedLikedBy = List<String>.from(post.likedBy);
      if (isLiked) {
        updatedLikedBy.remove(userId);
      } else {
        updatedLikedBy.add(userId);
      }

      final updatedPost = post.copyWith(
        likedBy: updatedLikedBy,
        likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );

      final updatedPosts = List<PostModel>.from(state.posts);
      updatedPosts[postIndex] = updatedPost;

      state = state.copyWith(posts: updatedPosts);

      // Update in Firebase
      await FirebaseService.updatePostLikes(
          postId, updatedLikedBy, updatedPost.likesCount);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newPosts = await FirebaseService.getPostsPaginated(
        lastDocumentId: state.lastDocumentId,
        limit: 10,
      );

      if (newPosts.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      final allPosts = [...state.posts, ...newPosts];
      state = state.copyWith(
        isLoading: false,
        posts: allPosts,
        lastDocumentId: newPosts.last.id,
        hasMore: newPosts.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      posts: [],
      hasMore: true,
      lastDocumentId: null,
    );
    await loadMorePosts();
  }

  // Add post to local state (for real-time updates)
  void addPost(PostModel post) {
    final updatedPosts = [post, ...state.posts];
    state = state.copyWith(posts: updatedPosts);
  }

  // Update post in local state
  void updatePost(PostModel updatedPost) {
    final updatedPosts = state.posts.map((post) {
      return post.id == updatedPost.id ? updatedPost : post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  // Remove post from local state
  void removePost(String postId) {
    final updatedPosts =
        state.posts.where((post) => post.id != postId).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Get filtered posts
  List<PostModel> getFilteredPosts({
    PostType? type,
    bool? isAnnouncement,
    bool? isPinned,
  }) {
    return state.posts.where((post) {
      if (type != null && post.type != type) return false;
      if (isAnnouncement != null && post.isAnnouncement != isAnnouncement) {
        return false;
      }
      if (isPinned != null && post.isPinned != isPinned) return false;
      return true;
    }).toList();
  }

  // Get announcements
  List<PostModel> get announcements {
    return getFilteredPosts(isAnnouncement: true);
  }

  // Get regular posts
  List<PostModel> get regularPosts {
    return getFilteredPosts(isAnnouncement: false);
  }

  // Get pinned posts
  List<PostModel> get pinnedPosts {
    return getFilteredPosts(isPinned: true);
  }
}
