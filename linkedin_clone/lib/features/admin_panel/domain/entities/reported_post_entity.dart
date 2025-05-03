class ReportedPost {
  final String id;
  final String status;
  final String postContent;
  final String? postMedia;
  final String postAuthor;
  final String postAuthorRole;
  final String? postAuthorAvatar;
  final String postAuthorType;
  final String reportedBy;
  final String? reporterAvatar;
  final String reason;
  final DateTime reportedAt;

  ReportedPost({
    required this.id,
    required this.status,
    required this.postContent,
    required this.postMedia,
    required this.postAuthor,
    required this.postAuthorRole,
    required this.postAuthorAvatar,
    required this.postAuthorType,
    required this.reportedBy,
    required this.reporterAvatar,
    required this.reason,
    required this.reportedAt,
  });
  factory ReportedPost.fake() => ReportedPost(
    id: '1',
    reason: 'Spam',
    reportedBy: 'User A',
    postAuthor: 'Author X',
    postAuthorRole: 'Engineer',
    postAuthorAvatar: null,
    reporterAvatar: null,
    postContent: 'Fake content',
    postMedia: null,
    reportedAt: DateTime.now(),
    status: 'Pending',
    postAuthorType: 'User',
  );
}
