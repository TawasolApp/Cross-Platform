import '../../domain/entities/post_entity.dart';
import 'repost_detail_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    super.authorPicture,
    required super.authorBio,
    required super.content,
    super.media,
    super.likes = 0,
    super.comments = 0,
    super.shares = 0,
    super.taggedUsers,
    required super.visibility,
    required super.authorType,
    required super.isLiked,
    required super.timestamp,
    super.repostDetails,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorPicture: json['authorPicture'] ?? "https://default.image/url.png",
      authorBio: json['authorBio'],
      content: json['content'],
      media:
          (json['media'] as List<dynamic>?)?.cast<String>() ??
          [], // ✅ Handle null
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      taggedUsers: (json['taggedUsers'] as List<dynamic>?)?.cast<String>(),
      visibility: json['visibility'],
      authorType: json['authorType'],
      isLiked: json['reactType'] == "Like",
      timestamp: DateTime.parse(json['timestamp']),
      repostDetails:
          json['repostDetails'] != null
              ? RepostDetailsModel.fromJson(json['repostDetails'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPicture': authorPicture,
      'authorBio': authorBio,
      'content': content,
      'media': media,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'taggedUsers': taggedUsers,
      'visibility': visibility,
      'authorType': authorType,
      'reactType': isLiked ? "Like" : null,
      'timestamp': timestamp.toIso8601String(),
      'repostDetails':
          repostDetails != null
              ? (repostDetails as RepostDetailsModel).toJson()
              : null,
    };
  }
}
