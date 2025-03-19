import '../../domain/entities/post_entity.dart';
import 'repost_detail_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required String id,
    required String authorId,
    required String authorName,
    String? authorPicture,
    required String authorBio,
    required String content,
    required List<String> media,
    required int likes,
    required int comments,
    required int shares,
    List<String>? taggedUsers,
    required String visibility,
    required String authorType,
    required bool isLiked,
    RepostDetailsModel? repostDetails, // ✅ Use RepostDetailsModel
    required DateTime timestamp,
  }) : super(
         id: id,
         authorId: authorId,
         authorName: authorName,
         authorPicture: authorPicture,
         authorBio: authorBio,
         content: content,
         media: media,
         likes: likes,
         comments: comments,
         shares: shares,
         taggedUsers: taggedUsers,
         visibility: visibility,
         authorType: authorType,
         isLiked: isLiked,
         repostDetails: repostDetails, // ✅ Updated
         timestamp: timestamp,
       );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorPicture: json['authorPicture'],
      authorBio: json['authorBio'],
      content: json['content'],
      media: List<String>.from(json['media'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      taggedUsers:
          (json['taggedUsers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      visibility: json['visibility'],
      authorType: json['authorType'],
      isLiked: json['isLiked'] ?? false,
      repostDetails:
          json['repostDetails'] != null
              ? RepostDetailsModel.fromJson(json['repostDetails']) // ✅ FIXED
              : null,
      timestamp: DateTime.parse(json['timestamp']),
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
      'isLiked': isLiked,
      'repostDetails':
          repostDetails != null
              ? (repostDetails as RepostDetailsModel).toJson()
              : null,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
