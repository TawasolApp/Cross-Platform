class JobListingEntity {
  final String id;
  final String company;
  final String title;
  final String reportedBy;
  final String reason;
  final String status;

  JobListingEntity({
    required this.id,
    required this.company,
    required this.title,
    required this.reportedBy,
    required this.reason,
    required this.status,
  });
}
