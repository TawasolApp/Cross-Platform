import '../entities/report_entity.dart';
import '../entities/job_listing_entity.dart';
import '../entities/analytics_entity.dart';

abstract class AdminRepository {
  Future<List<ReportEntity>> getReports({String? status, String? type});
  Future<void> resolveReport(String reportId, String action, String? comment);
  Future<List<JobListingEntity>> getFlaggedJobs();
  Future<void> deleteJobListing(String jobId);
  Future<UserAnalytics> getUserAnalytics();
  Future<PostAnalytics> getPostAnalytics();
  Future<JobAnalytics> getJobAnalytics();
  //Future<void> deleteReport(String reportId);
}
