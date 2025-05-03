import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/report_model.dart';
import '../models/job_listing_model.dart';

import '../models/user_analytics_model.dart';
import '../models/job_analytics_model.dart';
import '../models/post_analytics_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token_service.dart';

abstract class AdminRemoteDataSource {
  Future<Either<Failure, UserAnalyticsModel>> getUserAnalytics();
  Future<Either<Failure, PostAnalyticsModel>> getPostAnalytics();
  Future<Either<Failure, JobAnalyticsModel>> getJobAnalytics();
  Future<Either<Failure, String>> ignoreFlaggedJob(String jobId);
  Future<void> resolveReport({
    required String reportId,
    required String action,
    String? comment,
  });
  Future<List<ReportModel>> getReports({String? status, String? type});
  Future<List<JobListingModel>> getFlaggedJobListings();
  Future<void> deleteJobListing(String jobId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl(this.dio);
  Future<String> _getToken() async {
    final token = await TokenService.getToken();
    if (token == null) throw TokenException("Token not found");
    return token;
  }

  @override
  Future<List<ReportModel>> getReports({String? status, String? type}) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/admin/reports',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          if (status != null) 'status': status,
          if (type != null) 'type': type,
        },
      );

      final List data = response.data['reports'];
      return data.map((json) => ReportModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch reports: $e');
    }
  }

  @override
  Future<void> resolveReport({
    required String reportId,
    required String action,
    String? comment,
  }) async {
    final token = await _getToken();
    await dio.post(
      '/admin/reports/$reportId/resolve',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {'action': action, if (comment != null) 'comment': comment},
    );
  }

  @override
  Future<List<JobListingModel>> getFlaggedJobListings() async {
    final token = await _getToken();
    final response = await dio.get(
      'https://tawasolapp.me/api/admin/job-listings',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List data = response.data['job_listings'];
    return data.map((json) => JobListingModel.fromJson(json)).toList();
  }

  Future<void> deleteJobListing(String jobId) async {
    await dio.delete('https://tawasolapp.me/api/admin/job-listings/$jobId');
  }

  @override
  Future<Either<Failure, UserAnalyticsModel>> getUserAnalytics() async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/admin/analytics/users',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final model = UserAnalyticsModel.fromJson(response.data);
      print("✅ Fetched user analytics: ${response.data}");

      return Right(model);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Internal server error'));
      } else {
        return Left(ServerFailure(e.message ?? 'Unknown error'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostAnalyticsModel>> getPostAnalytics() async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/admin/analytics/posts',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final model = PostAnalyticsModel.fromJson(response.data);
      print("✅ Fetched post analytics: ${response.data}");
      return Right(model);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Internal server error'));
      } else {
        return Left(ServerFailure(e.message ?? 'Unknown error'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobAnalyticsModel>> getJobAnalytics() async {
    try {
      final token = await _getToken();

      final response = await dio.get(
        'https://tawasolapp.me/api/admin/analytics/jobs',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final model = JobAnalyticsModel.fromJson(response.data);
      print("✅ Fetched job analytics: ${response.data}");

      return Right(model);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print("❌ Unauthorized access: ${e.message}");
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 500) {
        print("❌ Internal server error: ${e.message}");
        return Left(ServerFailure('Internal server error'));
      } else {
        print("❌ Unknown error: ${e.message}");
        return Left(ServerFailure(e.message ?? 'Unknown error'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> ignoreFlaggedJob(String jobId) async {
    try {
      final token = await _getToken();
      final response = await dio.patch(
        '/admin/$jobId/ignore',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final message = response.data['message'] ?? 'Job ignored';
      return Right(message);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure("Unauthorized access"));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure("Forbidden: Manager access required"));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure("Job not found"));
      } else {
        return Left(ServerFailure(e.message ?? "Unknown error"));
      }
    }
  }
}
