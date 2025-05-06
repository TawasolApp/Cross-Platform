// data/models/post_model.dart
import 'package:linkedin_clone/features/feed/data/models/repost_detail_model.dart';

import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    super.authorPicture,
    required super.authorBio,
    required super.content,
    super.media,
    super.reactions,
    super.reactCounts,
    //super.likes = 0,
    super.comments = 0,
    super.shares = 0,
    super.taggedUsers,
    required super.visibility,
    required super.authorType,
    required super.reactType,
    //required super.isLiked,
    required super.timestamp,
    //super.repostDetails,
    super.isSaved = false,
    super.isFollowing = false,
    super.isConnected = false,
    super.isEdited = false,
    super.isSilentRepost = false,
    super.parentPost,
    super.parentPostId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorPicture: json['authorPicture'] ?? '',
      authorBio: json['authorBio'] ?? '',
      content: json['content'] ?? '',
      media: List<String>.from(json['media'] ?? []),
      reactions:
          json['reactions'] != null
              ? Map<String, bool>.from(json['reactions'])
              : <String, bool>{},

      reactCounts: Map<String, int>.from(json['reactCounts'] ?? {}),
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      taggedUsers: List<String>.from(json['taggedUsers'] ?? []),
      visibility: json['visibility'] ?? 'Public',
      authorType: json['authorType'] ?? 'User',
      reactType: json['reactType'] ?? 'None',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
      isSaved: json['isSaved'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      isConnected: json['isConnected'] ?? false,
      isEdited: json['isEdited'] ?? false,
      isSilentRepost: json['isSilentRepost'] ?? false,
      parentPost:
          json['parentPost'] != null
              ? PostModel.fromJson(json['parentPost'])
              : null,
      parentPostId: json['parentPostId'] ?? '',
    );
  }

  // Convert PostModel to PostEntity
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorPicture: authorPicture,
      authorBio: authorBio,
      content: content,
      media: media,
      reactions: reactions,
      reactCounts: reactCounts,
      comments: comments,
      shares: shares,
      taggedUsers: taggedUsers,
      visibility: visibility,
      authorType: authorType,
      reactType: reactType,
      timestamp: timestamp,
      isSaved: isSaved,
      isFollowing: isFollowing,
      isConnected: isConnected,
      isEdited: isEdited,
      isSilentRepost: isSilentRepost,
      parentPost: parentPost,
      parentPostId: parentPostId,
    );
  }
}
