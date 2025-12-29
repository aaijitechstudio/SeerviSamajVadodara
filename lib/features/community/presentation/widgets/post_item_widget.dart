import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../shared/data/firebase_service.dart';
import '../../../../core/repositories/repository_providers.dart';
import 'comments_sheet.dart';

class PostItemWidget extends ConsumerStatefulWidget {
  final PostModel post;
  final VoidCallback? onPostUpdated;
  final bool?
      isAdminPost; // Optional: if provided, use this instead of checking

  const PostItemWidget({
    super.key,
    required this.post,
    this.onPostUpdated,
    this.isAdminPost,
  });

  @override
  ConsumerState<PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends ConsumerState<PostItemWidget> {
  late PostModel _post;
  bool _isLiking = false;
  bool? _isAdmin;
  bool _isLoadingAdminStatus = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    if (widget.isAdminPost != null) {
      _isAdmin = widget.isAdminPost;
    } else {
      _checkAdminStatus();
    }
  }

  Future<void> _checkAdminStatus() async {
    if (_isLoadingAdminStatus) return;

    setState(() {
      _isLoadingAdminStatus = true;
    });

    try {
      final user = await FirebaseService.getUserData(_post.authorId);
      if (mounted) {
        setState(() {
          _isAdmin = user?.isAdmin ?? _post.isAnnouncement;
          _isLoadingAdminStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAdmin = _post.isAnnouncement; // Fallback to isAnnouncement
          _isLoadingAdminStatus = false;
        });
      }
    }
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

      if (postRepository == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Firebase is not initialized. Please restart the app.'),
            ),
          );
        }
        return;
      }

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

  bool get _isAdminPost {
    return _isAdmin ?? _post.isAnnouncement;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.user?.id;
    final isLiked =
        currentUserId != null && _post.likedBy.contains(currentUserId);
    final isAuthor = currentUserId == _post.authorId;
    final isAdminPost = _isAdminPost;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            isAdminPost ? AppColors.backgroundCream : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: isAdminPost
            ? Border(
                left: BorderSide(
                  color: AppColors.primaryOrange,
                  width: 4,
                ),
              )
            : null,
        boxShadow: isAdminPost
            ? [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
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
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _post.authorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isAdminPost
                                      ? AppColors.textPrimary
                                      : AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdminPost) ...[
                              const SizedBox(width: 6),
                              _buildOfficialBadge(),
                            ],
                            if (_post.isPinned) ...[
                              const SizedBox(width: 6),
                              _buildPinnedBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppUtils.formatDateTime(_post.createdAt),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
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
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
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
                      color: isLiked ? Colors.red : AppColors.textSecondary,
                    ),
                    onPressed: _isLiking ? null : _toggleLike,
                  ),
                  Text(
                    '${_post.likesCount}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      Icons.comment_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _showComments,
                  ),
                  Text(
                    '${_post.commentsCount}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      // TODO: Implement share
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfficialBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 14,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            'Official',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.push_pin,
            size: 14,
            color: Colors.blue[800],
          ),
          const SizedBox(width: 4),
          Text(
            'Pinned',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages() {
    if (_post.imageUrls == null || _post.imageUrls!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_post.imageUrls!.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        child: CachedNetworkImage(
          imageUrl: _post.imageUrls!.first,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          memCacheWidth: 800, // Limit memory usage
          memCacheHeight: 400,
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
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              child: CachedNetworkImage(
                imageUrl: _post.imageUrls![index],
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                memCacheWidth: 400, // Limit memory usage
                memCacheHeight: 400,
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

              if (postRepository == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Firebase is not initialized. Please restart the app.'),
                    ),
                  );
                }
                return;
              }

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
