import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_post_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_user_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/repositories/admin_repository.dart';
import '../data_sources/admin_remote_data_source.dart';
import '../../domain/entities/post_analytics_entity.dart';
import '../../domain/entities/job_analytics_entity.dart';
import '../../domain/entities/user_analytics_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../jobs/domain/entities/job_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReportedPost>> fetchReportedPosts({String? status}) {
    return remoteDataSource.fetchReportedPosts(status: status);
  }

  @override
  Future<List<ReportedUser>> fetchReportedUsers({String? status}) {
    return remoteDataSource.fetchReportedUsers(status: status);
  }

  @override
  Future<void> resolveReport(String reportId, String action, String comment) {
    return remoteDataSource.resolveReport(reportId, action, comment);
  }

  @override
  Future<void> deleteReportedPost(String companyId, String postId) {
    return remoteDataSource.deleteReportedPost(companyId, postId);
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

  @override
  Future<Either<Failure, List<Job>>> getJobListings({
    required int page,
    required int limit,
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
  }) {
    return remoteDataSource.getJobListings(
      page: page,
      limit: limit,
      keyword: keyword,
      location: location,
      industry: industry,
      experienceLevel: experienceLevel,
      company: company,
      minSalary: minSalary,
      maxSalary: maxSalary,
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteJobListing(String jobId) {
    return remoteDataSource.deleteJobListing(jobId);
  }
}
