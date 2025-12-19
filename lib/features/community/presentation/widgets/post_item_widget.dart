import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../../../../core/repositories/repository_providers.dart';
import 'comments_sheet.dart';

class PostItemWidget extends ConsumerStatefulWidget {
  final PostModel post;
  final VoidCallback? onPostUpdated;

  const PostItemWidget({
    super.key,
    required this.post,
    this.onPostUpdated,
  });

  @override
  ConsumerState<PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends ConsumerState<PostItemWidget> {
  late PostModel _post;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  Future<void> _toggleLike() async {
    final authState = ref.read(authControllerProvider);
    final currentUserId = authState.user?.id;

    if (currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to like posts')),
        );
      }
      return;
    }

    if (_isLiking) return;

    setState(() {
      _isLiking = true;
    });

    try {
      final postRepository = ref.read(postRepositoryProvider);
      final isLiked = _post.likedBy.contains(currentUserId);
      final newLikedBy = List<String>.from(_post.likedBy);

      if (isLiked) {
        newLikedBy.remove(currentUserId);
      } else {
        newLikedBy.add(currentUserId);
      }

      final result = await postRepository.updatePostLikes(
        postId: _post.id,
        likedBy: newLikedBy,
        likesCount: newLikedBy.length,
      );

      if (result.failure == null && result.data != null) {
        setState(() {
          _post = result.data!;
        });
        widget.onPostUpdated?.call();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(result.failure?.message ?? 'Failed to update like')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        post: _post,
        onCommentAdded: () {
          widget.onPostUpdated?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.user?.id;
    final isLiked =
        currentUserId != null && _post.likedBy.contains(currentUserId);
    final isAuthor = currentUserId == _post.authorId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _post.authorProfileImage != null
                      ? CachedNetworkImageProvider(_post.authorProfileImage!)
                      : null,
                  child: _post.authorProfileImage == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        AppUtils.formatDateTime(_post.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_post.isAnnouncement || _post.isPinned)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _post.isPinned
                          ? Colors.blue[100]
                          : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _post.isPinned ? '📌 Pinned' : '📢 Announcement',
                      style: TextStyle(
                        color: _post.isPinned
                            ? Colors.blue[800]
                            : Colors.orange[800],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isAuthor)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              _post.content,
              style: const TextStyle(fontSize: 16),
            ),

            // Media
            if (_post.hasImages) ...[
              const SizedBox(height: 12),
              _buildImages(),
            ],

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: _isLiking ? null : _toggleLike,
                ),
                Text('${_post.likesCount}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: _showComments,
                ),
                Text('${_post.commentsCount}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    // TODO: Implement share
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    if (_post.imageUrls == null || _post.imageUrls!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_post.imageUrls!.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: _post.imageUrls!.first,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _post.imageUrls!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: _post.imageUrls![index],
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final postRepository = ref.read(postRepositoryProvider);
              final result = await postRepository.deletePost(_post.id);
              if (result.failure == null && result.success == true) {
                widget.onPostUpdated?.call();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post deleted')),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(result.failure?.message ??
                            'Failed to delete post')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
