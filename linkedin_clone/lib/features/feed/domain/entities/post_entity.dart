import './sub_post_entities.dart';

class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPicture;
  final String authorBio;
  final String content;
  final List<String> media;
  final int likes;
  final int comments;
  final int shares;
  final List<String>? taggedUsers;
  final String visibility;
  final String authorType;
  final bool isLiked;
  final RepostDetails? repostDetails;
  final DateTime timestamp;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPicture, //add default url
    required this.authorBio,
    required this.content,
    required this.media,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.taggedUsers,
    required this.visibility,
    required this.authorType,
    required this.isLiked,
    required this.timestamp,
    this.repostDetails,
  });
}
