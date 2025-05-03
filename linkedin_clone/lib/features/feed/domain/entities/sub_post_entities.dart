class RepostDetails {
  final String authorId;
  final String postId;
  final String content;
  final List<String>? taggedUsers;
  final String visibility;
  final String authorType;

  const RepostDetails({
    required this.authorId,
    required this.postId,
    required this.content,
    this.taggedUsers,
    required this.visibility,
    required this.authorType,
  });
}
