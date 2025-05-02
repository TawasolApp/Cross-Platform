import 'package:flutter/material.dart';
import '../../domain/entities/reported_post_entity.dart';
import '../../domain/entities/reported_user_entity.dart';
import '../../domain/usecases/get_reported_posts_usecase.dart';
import '../../domain/usecases/get_reported_users_usecase.dart';
import '../../domain/usecases/resolve_report_usecase.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/usecases/get_job_listings_usecase.dart';
import '../../domain/usecases/delete_job_listing_usecase.dart';
import '../../domain/usecases/get_user_analytics_usecase.dart';
import '../../domain/usecases/get_post_analytics_usecase.dart';
import '../../domain/usecases/get_job_analytics_usecase.dart';
import '../../domain/entities/user_analytics_entity.dart';
import '../../domain/entities/post_analytics_entity.dart';
import '../../domain/entities/job_analytics_entity.dart';
import '../../domain/usecases/ignore_flagged_job_usecase.dart';
import '../../domain/usecases/resolve_report_usecase.dart';
import '../../domain/usecases/delete_reported_post.dart';

class AdminProvider with ChangeNotifier {
  final FetchReportedPosts getReportedPostsUseCase;
  final FetchReportedUsers getReportedUsersUseCase;
  final ResolveReportUseCase resolveReportUseCase;
  final GetJobListingsUseCase getJobListingsUseCase;
  final DeleteJobListingUseCase deleteJobListingUseCase;
  final GetUserAnalyticsUseCase getUserAnalyticsUseCase;
  final GetPostAnalyticsUseCase getPostAnalyticsUseCase;
  final GetJobAnalyticsUseCase getJobAnalyticsUseCase;
  final IgnoreFlaggedJobUseCase ignoreFlaggedJobUseCase;
  final DeleteReportedPostUseCase deleteReportedPostUseCase;

  AdminProvider({
    required this.getReportedPostsUseCase,
    required this.resolveReportUseCase,
    required this.getJobListingsUseCase,
    required this.deleteJobListingUseCase,
    required this.getPostAnalyticsUseCase,
    required this.getUserAnalyticsUseCase,
    required this.getJobAnalyticsUseCase,
    required this.ignoreFlaggedJobUseCase,
    required this.getReportedUsersUseCase,
    required this.deleteReportedPostUseCase,
  });

  UserAnalytics? userAnalytics;
  PostAnalytics? postAnalytics;
  JobAnalytics? jobAnalytics;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<ReportedPost> _reportedPosts = [];
  List<ReportedPost> get reportedPosts => _reportedPosts;
  List<ReportedUser> _reportedUsers = [];
  List<ReportedUser> get reportedUsers => _reportedUsers;
  List<JobListingEntity> jobListings = [];

  Future<void> fetchReportedPosts({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reportedPosts = await getReportedPostsUseCase(status: status);
    } catch (e) {
      _errorMessage = "Failed to load reported posts";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReportedUsers({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reportedUsers = await getReportedUsersUseCase(status: status);
    } catch (e) {
      _errorMessage = "Failed to load reported users";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> resolveUserReport(
    String reportId,
    String action, {
    String comment = '',
  }) async {
    await resolveReportUseCase(
      reportId: reportId,
      action: action,
      comment: comment,
    );
    await fetchReportedUsers(); // refresh
  }

  Future<void> resolvePostReport(
    String reportId,
    String action, {
    String comment = '',
  }) async {
    await resolveReportUseCase(
      reportId: reportId,
      action: action,
      comment: comment,
    );
    await fetchReportedPosts(); // refresh
  }

  Future<void> deleteReportedPost(String companyId, String postId) async {
    await deleteReportedPostUseCase(companyId: companyId, postId: postId);
    await fetchReportedPosts();
  }

  Future<void> fetchJobListings() async {
    _isLoading = true;
    notifyListeners();

    try {
      jobListings = await getJobListingsUseCase();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteJob(String jobId) async {
    await deleteJobListingUseCase(jobId);
    jobListings.removeWhere((job) => job.id == jobId);
    notifyListeners();
  }

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userResult = await getUserAnalyticsUseCase();
      userResult.fold(
        (failure) {
          _errorMessage = failure.message;
          print("provider1: Error fetching user analytics: ${failure.message}");
        },
        (data) {
          userAnalytics = data;
          print(
            "provider: User analytics fetched successfully: ${data.totalUsers}",
          );
        },
      );

      final postResult = await getPostAnalyticsUseCase();
      postResult.fold(
        (failure) => _errorMessage ??= failure.message,
        (data) => postAnalytics = data,
      );

      final jobResult = await getJobAnalyticsUseCase();
      jobResult.fold(
        (failure) => _errorMessage ??= failure.message,
        (data) => jobAnalytics = data,
      );
    } catch (e, stack) {
      _errorMessage = "Provider: Unexpected error occurred: $e";
      print("Provider: Error fetching analytics: $e\n$stack");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> ignoreJob(String jobId) async {
    final result = await ignoreFlaggedJobUseCase(jobId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (message) {
        jobListings.removeWhere((job) => job.id == jobId);
        notifyListeners();
      },
    );
  }
}
