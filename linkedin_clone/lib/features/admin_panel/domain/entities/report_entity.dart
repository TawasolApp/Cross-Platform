class ReportEntity {
  final String id;
  final String type; // post, comment, profile, company
  final String reportedBy;
  final String reason;
  final String status;
  final DateTime reportedAt;

  ReportEntity({
    required this.id,
    required this.type,
    required this.reportedBy,
    required this.reason,
    required this.status,
    required this.reportedAt,
  });
}
