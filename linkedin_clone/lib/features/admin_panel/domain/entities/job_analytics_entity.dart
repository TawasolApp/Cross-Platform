import '../../../jobs/domain/entities/job_entity.dart';

class MostAppliedCompany {
  final String id;
  final int applicationCount;

  MostAppliedCompany({required this.id, required this.applicationCount});
  factory MostAppliedCompany.fromJson(Map<String, dynamic> json) {
    return MostAppliedCompany(
      id: json['_id'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
    );
  }
}

class JobAnalytics {
  final int totalJobs;
  final MostAppliedCompany mostAppliedCompany;
  final Job mostAppliedJob;

  JobAnalytics({
    required this.totalJobs,
    required this.mostAppliedCompany,
    required this.mostAppliedJob,
  });
}
