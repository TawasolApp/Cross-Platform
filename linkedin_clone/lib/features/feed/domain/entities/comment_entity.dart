class CommentEntity {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorPicture;
  final String authorBio;
  final String content;
  final List<String> taggedUsers;
  final int reactCount;
  final List<CommentEntity> replies;
  final DateTime timestamp;
  final bool isReply;
  final int repliesCount;

  CommentEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorPicture,
    required this.authorBio,
    required this.content,
    required this.taggedUsers,
    required this.replies,
    required this.reactCount,
    required this.timestamp,
    required this.isReply,
    required this.repliesCount,
  });
}
