import './sub_post_entities.dart';

class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPicture;
  final String authorBio;
  final String content;
  final List<String>? media;
  final int likes;
  final int comments;
  final int shares;
  final List<String>? taggedUsers;
  final String visibility;
  final String authorType;
  final bool isLiked;
  final RepostDetails? repostDetails;
  final DateTime timestamp;
  final bool isSaved;
  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPicture,
    required this.authorBio,
    required this.content,
    this.media,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.taggedUsers,
    required this.visibility,
    required this.authorType,
    required this.isLiked,
    required this.timestamp,
    this.repostDetails,
    this.isSaved = false,
  });
  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorPicture,
    String? authorBio,
    String? content,
    List<String>? media,
    int? likes,
    int? comments,
    int? shares,
    List<String>? taggedUsers,
    String? visibility,
    String? authorType,
    bool? isLiked,
    DateTime? timestamp,
    RepostDetails? repostDetails,
    bool? isSaved,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPicture: authorPicture ?? this.authorPicture,
      authorBio: authorBio ?? this.authorBio,
      content: content ?? this.content,
      media: media ?? this.media,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      visibility: visibility ?? this.visibility,
      authorType: authorType ?? this.authorType,
      isLiked: isLiked ?? this.isLiked,
      timestamp: timestamp ?? this.timestamp,
      repostDetails: repostDetails ?? this.repostDetails,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
