import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final bool isPinned;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.isPinned = false,
    this.isActive = true,
    this.metadata,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPinned: map['isPinned'] ?? false,
      isActive: map['isActive'] ?? true,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': Timestamp.fromDate(createdAt),
      'isPinned': isPinned,
      'isActive': isActive,
      'metadata': metadata,
    };
  }
}
