import 'package:linkedin_clone/features/admin_panel/domain/entities/user_analytics_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../entities/reported_user_entity.dart';
import '../entities/reported_post_entity.dart';
import '../entities/post_analytics_entity.dart';
import '../entities/job_analytics_entity.dart';

abstract class AdminRepository {
  Future<List<ReportedPost>> fetchReportedPosts({String? status});
  Future<List<ReportedUser>> fetchReportedUsers({String? status});
  Future<void> resolveReport(String reportId, String action, String comment);
  Future<void> deleteReportedPost(String companyId, String postId);
  Future<Either<Failure, UserAnalytics>> getUserAnalytics();
  Future<Either<Failure, PostAnalytics>> getPostAnalytics();
  Future<Either<Failure, JobAnalytics>> getJobAnalytics();
  Future<Either<Failure, String>> ignoreFlaggedJob(String jobId);
  Future<Either<Failure, Unit>> deleteJobListing(String jobId);
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
  });
}
