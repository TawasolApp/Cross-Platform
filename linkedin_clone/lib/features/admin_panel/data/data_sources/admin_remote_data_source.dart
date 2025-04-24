import 'package:dio/dio.dart';
import '../models/report_model.dart';
import '../models/job_listing_model.dart';
import '../models/analytics_model.dart';
import '../../domain/entities/analytics_entity.dart';

class AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSource(this.dio);

  Future<List<ReportModel>> getReports({String? status, String? type}) async {
    final response = await dio.get(
      '/admin/reports',
      queryParameters: {
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      },
    );

    final List data = response.data['reports'];
    return data.map((json) => ReportModel.fromJson(json)).toList();
  }

  Future<void> resolveReport({
    required String reportId,
    required String action,
    String? comment,
  }) async {
    await dio.post(
      '/admin/reports/$reportId/resolve',
      data: {'action': action, if (comment != null) 'comment': comment},
    );
  }

  Future<List<JobListingModel>> getFlaggedJobListings() async {
    final response = await dio.get('/admin/job-listings');
    final List data = response.data['job_listings'];
    return data.map((json) => JobListingModel.fromJson(json)).toList();
  }

  Future<void> deleteJobListing(String jobId) async {
    await dio.delete('/admin/job-listings/$jobId');
  }

  Future<UserAnalytics> getUserAnalytics() async {
    final res = await dio.get('/admin/analytics/users');
    return AnalyticsModel.userFromJson(res.data);
  }

  Future<PostAnalytics> getPostAnalytics() async {
    final res = await dio.get('/admin/analytics/posts');
    return AnalyticsModel.postFromJson(res.data);
  }

  Future<JobAnalytics> getJobAnalytics() async {
    final res = await dio.get('/admin/analytics/jobs');
    return AnalyticsModel.jobFromJson(res.data);
  }
}
