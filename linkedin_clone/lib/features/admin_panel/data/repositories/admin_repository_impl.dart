import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/report_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/repositories/admin_repository.dart';
import '../data_sources/admin_remote_data_source.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/entities/post_analytics_entity.dart';
import '../../domain/entities/job_analytics_entity.dart';
import '../../domain/entities/user_analytics_entity.dart';
import 'package:dartz/dartz.dart';

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
  Future<Either<Failure, UserAnalytics>> getUserAnalytics() async {
    final result = await remoteDataSource.getUserAnalytics();
    return result.map<UserAnalytics>((model) => model);
  }

  @override
  Future<Either<Failure, PostAnalytics>> getPostAnalytics() async {
    final result = await remoteDataSource.getPostAnalytics();
    return result.map<PostAnalytics>((model) => model);
  }

  @override
  Future<Either<Failure, JobAnalytics>> getJobAnalytics() async {
    final result = await remoteDataSource.getJobAnalytics();
    return result.map<JobAnalytics>((model) => model);
  }

  @override
  Future<Either<Failure, String>> ignoreFlaggedJob(String jobId) {
    return remoteDataSource.ignoreFlaggedJob(jobId);
  }
}
