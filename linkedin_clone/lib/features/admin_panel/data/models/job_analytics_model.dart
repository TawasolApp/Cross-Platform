import '../../domain/entities/job_analytics_entity.dart';

class JobAnalyticsModel extends JobAnalytics {
  JobAnalyticsModel({
    required int totalJobs,
    required List<String> mostAppliedCompanies,
  }) : super(totalJobs: totalJobs, mostAppliedCompanies: mostAppliedCompanies);

  factory JobAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return JobAnalyticsModel(
      totalJobs: json['totalJobs'] ?? 0,
      mostAppliedCompanies: List<String>.from(
        json['mostAppliedCompanies'] ?? [],
      ),
    );
  }
}
