import 'package:flutter/material.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/get_reports_usecase.dart';
import '../../domain/usecases/resolve_report_usecase.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/usecases/get_job_listings_usecase.dart';
import '../../domain/usecases/delete_job_listing_usecase.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/usecases/get_analytics_usecase.dart';

class AdminProvider with ChangeNotifier {
  final GetReportsUseCase getReportsUseCase;
  final ResolveReportUseCase resolveReportUseCase;
  final GetJobListingsUseCase getJobListingsUseCase;
  final DeleteJobListingUseCase deleteJobListingUseCase;
  final GetUserAnalyticsUseCase getUserAnalyticsUseCase;
  final GetPostAnalyticsUseCase getPostAnalyticsUseCase;
  final GetJobAnalyticsUseCase getJobAnalyticsUseCase;

  AdminProvider({
    required this.getReportsUseCase,
    required this.resolveReportUseCase,
    required this.getJobListingsUseCase,
    required this.deleteJobListingUseCase,
    required this.getPostAnalyticsUseCase,
    required this.getUserAnalyticsUseCase,
    required this.getJobAnalyticsUseCase,
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
    notifyListeners();

    try {
      userAnalytics = await getUserAnalyticsUseCase();
      postAnalytics = await getPostAnalyticsUseCase();
      jobAnalytics = await getJobAnalyticsUseCase();
    } catch (_) {}

    isLoading = false;
    notifyListeners();
  }
}
