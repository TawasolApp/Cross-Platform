class PostAnalytics {
  final int totalPosts;
  final int totalShares;
  final int totalComments;
  final int totalReacts;
  final String topPostId;

  const PostAnalytics({
    required this.totalPosts,
    required this.totalShares,
    required this.totalComments,
    required this.totalReacts,
    required this.topPostId,
  });
}
