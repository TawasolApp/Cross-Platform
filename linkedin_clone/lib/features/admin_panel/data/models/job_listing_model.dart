import '../../domain/entities/job_listing_entity.dart';

class JobListingModel extends JobListingEntity {
  JobListingModel({
    required super.id,
    required super.company,
    required super.title,
    required super.reportedBy,
    required super.reason,
    required super.status,
  });

  factory JobListingModel.fromJson(Map<String, dynamic> json) {
    return JobListingModel(
      id: json['id'],
      company: json['company'],
      title: json['title'],
      reportedBy: json['reported_by'],
      reason: json['reason'],
      status: json['status'],
    );
  }
}
