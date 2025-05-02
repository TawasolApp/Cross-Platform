import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/reported_post_model.dart';
import '../models/reported_user_model.dart';
import '../models/job_listing_model.dart';

import '../models/user_analytics_model.dart';
import '../models/job_analytics_model.dart';
import '../models/post_analytics_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token_service.dart';
import '../../../jobs/data/model/job_model.dart';

abstract class AdminRemoteDataSource {
  Future<Either<Failure, UserAnalyticsModel>> getUserAnalytics();
  Future<Either<Failure, PostAnalyticsModel>> getPostAnalytics();
  Future<Either<Failure, JobAnalyticsModel>> getJobAnalytics();
  Future<void> resolveReport(String reportId, String action, String comment);
  Future<void> deleteReportedPost(String companyId, String postId);
  Future<List<ReportedPostModel>> fetchReportedPosts({String? status});
  Future<List<ReportedUserModel>> fetchReportedUsers({String? status});
  Future<Either<Failure, String>> ignoreFlaggedJob(String jobId);
  Future<Either<Failure, List<JobModel>>> getJobListings({
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
  Future<Either<Failure, Unit>> deleteJobListing(String jobId);
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
  Future<List<ReportedPostModel>> fetchReportedPosts({String? status}) async {
    final token = await _getToken();
    final response = await dio.get(
      'https://tawasolapp.me/api/admin/reports/posts',
      queryParameters: status != null ? {'status': status} : null,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data as List)
        .map((json) => ReportedPostModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ReportedUserModel>> fetchReportedUsers({String? status}) async {
    final token = await _getToken();
    final response = await dio.get(
      'https://tawasolapp.me/api/admin/reports/users',
      queryParameters: status != null ? {'status': status} : null,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data as List)
        .map((json) => ReportedUserModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> resolveReport(
    String reportId,
    String action,
    String comment,
  ) async {
    try {
      final token = await _getToken();
      await dio.patch(
        'https://tawasolapp.me/api/admin/reports/$reportId/resolve',
        data: {"action": action, "comment": comment},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e, stackTrace) {
      print("Error resolving report: $e\n$stackTrace");
      throw ServerException("Failed to resolve report");
    }
  }

  @override
  Future<void> deleteReportedPost(String companyId, String postId) async {
    final token = await _getToken();
    await dio.delete(
      'https://tawasolapp.me/api/posts/$companyId/$postId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<Either<Failure, List<JobModel>>> getJobListings({
    required int page,
    required int limit,
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
  }) async {
    try {
      final token = await _getToken();

      final response = await dio.get(
        'https://tawasolapp.me/api/jobs',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (keyword != null) 'keyword': keyword,
          if (location != null) 'location': location,
          if (industry != null) 'industry': industry,
          if (experienceLevel != null) 'experienceLevel': experienceLevel,
          if (company != null) 'company': company,
          if (minSalary != null) 'minSalary': minSalary,
          if (maxSalary != null) 'maxSalary': maxSalary,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final jobs =
          (response.data['jobs'] as List)
              .map((e) => JobModel.fromJson(e))
              .toList();

      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch jobs"));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteJobListing(String jobId) async {
    try {
      final token = await _getToken();
      await dio.delete(
        'https://tawasolapp.me/api/jobs/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Failed to delete job"));
    }
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
        'https://tawasolapp.me/api/admin/$jobId/ignore',
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
