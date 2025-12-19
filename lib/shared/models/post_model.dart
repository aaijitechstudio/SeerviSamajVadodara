import 'package:cloud_firestore/cloud_firestore.dart';

enum PostType { text, image, video, announcement }

enum PostCategory {
  announcement, // Admin announcements
  discussion, // General discussion
  events, // Events and celebrations
  gallery, // Photo gallery
}

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorProfileImage;
  final String content;
  final PostType type;
  final List<String>? imageUrls;
  final List<String>? videoUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int commentsCount;
  final List<String> likedBy;
  final bool isAnnouncement;
  final bool isPinned;
  final PostCategory category; // Section/category for community board
  final Map<String, dynamic>? metadata;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorProfileImage,
    required this.content,
    required this.type,
    this.imageUrls,
    this.videoUrls,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.likedBy = const [],
    this.isAnnouncement = false,
    this.isPinned = false,
    this.category = PostCategory.discussion,
    this.metadata,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorProfileImage: map['authorProfileImage'],
      content: map['content'] ?? '',
      type: PostType.values.firstWhere(
        (e) => e.toString() == 'PostType.${map['type']}',
        orElse: () => PostType.text,
      ),
      imageUrls:
          map['imageUrls'] != null ? List<String>.from(map['imageUrls']) : null,
      videoUrls:
          map['videoUrls'] != null ? List<String>.from(map['videoUrls']) : null,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      likedBy: map['likedBy'] != null ? List<String>.from(map['likedBy']) : [],
      isAnnouncement: map['isAnnouncement'] ?? false,
      isPinned: map['isPinned'] ?? false,
      category: map['category'] != null
          ? PostCategory.values.firstWhere(
              (e) => e.toString() == 'PostCategory.${map['category']}',
              orElse: () => PostCategory.discussion,
            )
          : PostCategory.discussion,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorProfileImage': authorProfileImage,
      'content': content,
      'type': type.toString().split('.').last,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': likedBy,
      'isAnnouncement': isAnnouncement,
      'isPinned': isPinned,
      'category': category.toString().split('.').last,
      'metadata': metadata,
    };
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorProfileImage,
    String? content,
    PostType? type,
    List<String>? imageUrls,
    List<String>? videoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    List<String>? likedBy,
    bool? isAnnouncement,
    bool? isPinned,
    PostCategory? category,
    Map<String, dynamic>? metadata,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorProfileImage: authorProfileImage ?? this.authorProfileImage,
      content: content ?? this.content,
      type: type ?? this.type,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedBy: likedBy ?? this.likedBy,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;
  bool get hasVideos => videoUrls != null && videoUrls!.isNotEmpty;
  bool get isLiked => likedBy
      .isNotEmpty; // This would need current user ID in real implementation

  @override
  String toString() {
    return 'PostModel(id: $id, authorName: $authorName, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
