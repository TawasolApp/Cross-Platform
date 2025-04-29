import 'package:flutter/material.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/get_reports_usecase.dart';
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

class AdminProvider with ChangeNotifier {
  final GetReportsUseCase getReportsUseCase;
  final ResolveReportUseCase resolveReportUseCase;
  final GetJobListingsUseCase getJobListingsUseCase;
  final DeleteJobListingUseCase deleteJobListingUseCase;
  final GetUserAnalyticsUseCase getUserAnalyticsUseCase;
  final GetPostAnalyticsUseCase getPostAnalyticsUseCase;
  final GetJobAnalyticsUseCase getJobAnalyticsUseCase;
  final IgnoreFlaggedJobUseCase ignoreFlaggedJobUseCase;

  AdminProvider({
    required this.getReportsUseCase,
    required this.resolveReportUseCase,
    required this.getJobListingsUseCase,
    required this.deleteJobListingUseCase,
    required this.getPostAnalyticsUseCase,
    required this.getUserAnalyticsUseCase,
    required this.getJobAnalyticsUseCase,
    required this.ignoreFlaggedJobUseCase,
  });

  UserAnalytics? userAnalytics;
  PostAnalytics? postAnalytics;
  JobAnalytics? jobAnalytics;
  bool isLoading = false;
  String? errorMessage;
  List<ReportEntity> reports = [];
  List<JobListingEntity> jobListings = [];

  Future<void> fetchReports({String? status, String? type}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      reports = await getReportsUseCase(status: status, type: type);
    } catch (e) {
      errorMessage = "Failed to load reports.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> resolveReport(
    String id,
    String action, {
    String? comment,
  }) async {
    try {
      await resolveReportUseCase(
        reportId: id,
        action: action,
        comment: comment,
      );
      reports.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      // optionally set an error state
    }
  }

  Future<void> fetchJobListings() async {
    isLoading = true;
    notifyListeners();

    try {
      jobListings = await getJobListingsUseCase();
    } catch (_) {}

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteJob(String jobId) async {
    await deleteJobListingUseCase(jobId);
    jobListings.removeWhere((job) => job.id == jobId);
    notifyListeners();
  }

  Future<void> fetchAnalytics() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userResult = await getUserAnalyticsUseCase();
      userResult.fold(
        (failure) {
          errorMessage = failure.message;
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
        (failure) => errorMessage ??= failure.message,
        (data) => postAnalytics = data,
      );

      final jobResult = await getJobAnalyticsUseCase();
      jobResult.fold(
        (failure) => errorMessage ??= failure.message,
        (data) => jobAnalytics = data,
      );
    } catch (e, stack) {
      errorMessage = "Provider: Unexpected error occurred: $e";
      print("Provider: Error fetching analytics: $e\n$stack");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> ignoreJob(String jobId) async {
    final result = await ignoreFlaggedJobUseCase(jobId);
    result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
      },
      (message) {
        jobListings.removeWhere((job) => job.id == jobId);
        notifyListeners();
      },
    );
  }
}
