class ReactionEntity {
  final String likeId;
  final String postId;
  final String authorId;
  final String authorType;
  final String type;
  final String authorName;
  final String authorPicture;
  final String authorBio;

  ReactionEntity({
    required this.likeId,
    required this.postId,
    required this.authorId,
    required this.authorType,
    required this.type,
    required this.authorName,
    required this.authorPicture,
    required this.authorBio,
  });
}
