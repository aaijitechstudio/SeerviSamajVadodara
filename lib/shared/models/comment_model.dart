import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorProfileImage;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorProfileImage,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      postId: map['postId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorProfileImage: map['authorProfileImage'],
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorProfileImage': authorProfileImage,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isDeleted': isDeleted,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorProfileImage,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorProfileImage: authorProfileImage ?? this.authorProfileImage,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, authorName: $authorName, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
