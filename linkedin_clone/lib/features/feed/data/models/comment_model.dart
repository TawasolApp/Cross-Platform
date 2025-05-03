import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.postId,
    required super.authorId,
    required super.authorName,
    required super.authorPicture,
    required super.authorBio,
    required super.content,
    required super.taggedUsers,
    required super.replies,
    required super.reactCount,
    required super.timestamp,
    required super.isReply,
    required super.repliesCount,
    required super.reactType,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorPicture: json['authorPicture'] ?? '',
      authorBio: json['authorBio'] ?? '',
      isReply: json['isReply'] ?? false,
      content: json['content'] ?? '',
      taggedUsers: List<String>.from(json['taggedUsers'] ?? []), // Fix here
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((x) => CommentModel.fromJson(x))
              .toList() ??
          [], // Fix here
      reactCount: json['reactCount'] ?? 0,
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
      repliesCount: json['repliesCount'] ?? 0,
      reactType: json['reactType'] ?? 'None', // Fix here
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPicture': authorPicture,
      'authorBio': authorBio,
      'content': content,
      'taggedUsers': taggedUsers,
      'replies': replies.map((x) => (x as CommentModel).toJson()).toList(),
      'reactCount': reactCount,
      'timestamp': timestamp.toIso8601String(),
      'isReply': isReply,
      'repliesCount': repliesCount,
      'reactType': reactType,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorPicture,
    String? authorBio,
    String? content,
    int? reactCount,
    DateTime? timestamp,
    List<String>? taggedUsers,
    List<CommentModel>? replies,
    bool? isReply,
    int? repliesCount,
    String? reactType,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPicture: authorPicture ?? this.authorPicture,
      authorBio: authorBio ?? this.authorBio,
      content: content ?? this.content,
      reactCount: reactCount ?? this.reactCount,
      timestamp: timestamp ?? this.timestamp,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      replies: replies ?? this.replies,
      isReply: isReply ?? this.isReply,
      repliesCount: repliesCount ?? this.repliesCount,
      reactType: reactType ?? this.reactType,
    );
  }
}
