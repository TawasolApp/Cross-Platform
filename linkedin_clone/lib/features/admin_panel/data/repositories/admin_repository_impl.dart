import 'package:linkedin_clone/features/admin_panel/domain/entities/report_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/repositories/admin_repository.dart';
import '../data_sources/admin_remote_data_source.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/entities/analytics_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReportEntity>> getReports({String? status, String? type}) {
    return remoteDataSource.getReports(status: status, type: type);
  }

  @override
  Future<void> resolveReport(String reportId, String action, String? comment) {
    return remoteDataSource.resolveReport(
      reportId: reportId,
      action: action,
      comment: comment,
    );
  }

  @override
  Future<List<JobListingEntity>> getFlaggedJobs() {
    return remoteDataSource.getFlaggedJobListings();
  }

  @override
  Future<void> deleteJobListing(String jobId) {
    return remoteDataSource.deleteJobListing(jobId);
  }

  @override
  Future<UserAnalytics> getUserAnalytics() {
    return remoteDataSource.getUserAnalytics();
  }

  @override
  Future<PostAnalytics> getPostAnalytics() {
    return remoteDataSource.getPostAnalytics();
  }

  @override
  Future<JobAnalytics> getJobAnalytics() {
    return remoteDataSource.getJobAnalytics();
  }
}
