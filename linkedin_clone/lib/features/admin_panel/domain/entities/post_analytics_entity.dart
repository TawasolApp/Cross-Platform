class PostAnalytics {
  final int totalPosts;
  final int totalShares;
  final int totalComments;
  final int totalReacts;
  final String postWithMostInteractions;
  final int postReportedCount;
  final String mostReportedPost;

  PostAnalytics({
    required this.totalPosts,
    required this.totalShares,
    required this.totalComments,
    required this.totalReacts,
    required this.postWithMostInteractions,
    required this.postReportedCount,
    required this.mostReportedPost,
  });
}
