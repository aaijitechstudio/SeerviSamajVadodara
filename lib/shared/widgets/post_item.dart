import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../../core/utils/app_utils.dart';
import 'video_player_widget.dart';

class PostItem extends StatelessWidget {
  final PostModel post;

  const PostItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 12),

            // Content
            _buildContent(context),

            // Media
            if (post.hasImages || post.hasVideos) ...[
              const SizedBox(height: 12),
              _buildMedia(context),
            ],

            const SizedBox(height: 12),

            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Profile Picture
        CircleAvatar(
          radius: 20,
          backgroundImage: post.authorProfileImage != null
              ? CachedNetworkImageProvider(post.authorProfileImage!)
              : null,
          child:
              post.authorProfileImage == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 12),

        // Author Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                AppUtils.formatDateTime(post.createdAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Post Type Indicator
        if (post.isAnnouncement)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Announcement',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // More Options
        PopupMenuButton<String>(
          onSelected: (value) {
            _handleMenuAction(context, value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
            ),
            if (post.authorId ==
                'current_user_id') // Would check actual current user
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      post.content,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildMedia(BuildContext context) {
    if (post.hasImages && post.imageUrls!.length == 1) {
      // Single Image
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: post.imageUrls!.first,
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
    } else if (post.hasImages && post.imageUrls!.length > 1) {
      // Multiple Images
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: post.imageUrls!.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrls![index],
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
    } else if (post.hasVideos) {
      // Videos - show first video, or list if multiple
      if (post.videoUrls!.length == 1) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: VideoPlayerWidget(videoUrl: post.videoUrls!.first),
        );
      } else {
        // Multiple videos - show as list
        return Column(
          children: post.videoUrls!.map((videoUrl) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: VideoPlayerWidget(videoUrl: videoUrl),
              ),
            );
          }).toList(),
        );
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Like Button
        IconButton(
          icon: Icon(
            post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? Colors.red : null,
          ),
          onPressed: () {
            // Handle like
          },
        ),
        Text('${post.likesCount}'),

        const SizedBox(width: 16),

        // Comment Button
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () {
            // Handle comments
          },
        ),
        Text('${post.commentsCount}'),

        const Spacer(),

        // Share Button
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {
            _handleMenuAction(context, 'share');
          },
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'share':
        // Handle share
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
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
            onPressed: () {
              Navigator.of(context).pop();
              // Handle delete
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
