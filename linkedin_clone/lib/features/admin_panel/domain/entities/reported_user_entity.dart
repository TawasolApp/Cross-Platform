class ReportedUser {
  final String id;
  final String status;
  final String reportedUser;
  final String reportedUserRole;
  final String? reportedUserAvatar;
  final String reportedBy;
  final String? reporterAvatar;
  final String reason;
  final DateTime reportedAt;

  ReportedUser({
    required this.id,
    required this.status,
    required this.reportedUser,
    required this.reportedUserRole,
    required this.reportedUserAvatar,
    required this.reportedBy,
    required this.reporterAvatar,
    required this.reason,
    required this.reportedAt,
  });
}
