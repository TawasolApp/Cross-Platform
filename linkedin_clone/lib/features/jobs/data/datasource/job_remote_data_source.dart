import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/jobs/data/model/application_model.dart';
import 'package:linkedin_clone/features/jobs/data/model/create_job_model.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import '../model/job_model.dart';

class JobRemoteDataSource {
  final String baseUrl = "https://tawasolapp.me/api";
  Future<List<JobModel>> getRecentJobs(
    String companyId, {
    int page = 1,
    int limit = 5,
  }) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/companies/$companyId/jobs?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response from get recent jobs: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(
          'CHECK THIS: ${jsonList.map((json) => JobModel.fromJson(json)).toList()}',
        );
        return jsonList.map((json) => JobModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recent jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recent jobs: $e');
    }
  }
Future<List<JobModel>> searchJobs({
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
    int page = 1,
    int limit = 5,
  }) async {
    final token = await TokenService.getToken();

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (location != null && location.isNotEmpty) 'location': location,
      if (industry != null && industry.isNotEmpty) 'industry': industry,
      if (experienceLevel != null && experienceLevel.isNotEmpty)
        'experienceLevel': experienceLevel,
      if (company != null && company.isNotEmpty) 'company': company,
      if (minSalary != null && minSalary > 0)
        'minSalary': minSalary.toStringAsFixed(0),
      if (maxSalary != null && maxSalary > 0)
        'maxSalary': maxSalary.toStringAsFixed(0),
    };

    final uri = Uri.parse(
      '$baseUrl/jobs',
    ).replace(queryParameters: queryParams);

    print('page: $page');
    print('limit: $limit');
    print('🔍 Searching jobs with query: $queryParams');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 GET ${uri.toString()}');
      print('📥 Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse['jobs'] ?? [];
        print('🔍 Search Results: $jsonList');
        return jsonList.map((e) => JobModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching jobs: $e');
      throw Exception('Error searching jobs: $e');
    }
  }
  Future<bool> addJob(CreateJobModel job, String companyId) async {
    final token = await TokenService.getToken();
    try {
      // Convert job model to JSON format
      final jobData = job.toJson();
      print('Job Data: $jobData');
      // Send the POST request to add the job
      final response = await http.post(
        Uri.parse('$baseUrl/companies/$companyId/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(jobData), // Convert jobData map to JSON string
      );
      print('Response: ${response.body}');
      // Handle the response
      if (response.statusCode == 201) {
        print('Job added successfully');
        return true;
      } else {
        // Handle errors, such as bad request or server issues
        print('Failed to add job. Status Code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding job: $e');
      return false;
    }
  }

  

  Future<bool> deleteJob(String jobId) async {
    final token = await TokenService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$jobId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> applyForJob(ApplyForJobEntity application) async {
    final token = await TokenService.getToken();
    print('resumeURL: ${application.resumeURL}');

    try {
      // Build the request body dynamically
      final body = {
        "jobId": application.jobId,
        "phoneNumber": application.phoneNumber,
      };

      // Only add resumeURL if it's not empty
      if (application.resumeURL.trim().isNotEmpty) {
        body["resumeURL"] = application.resumeURL.trim();
      }

      final response = await http.post(
        Uri.parse('$baseUrl/jobs/apply'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error applying for job: $e");
      return false;
    }
  }

  Future<List<ApplicationModel>> getApplicants(
    String jobId, {
    int page = 1,
    int limit = 5,
  }) async {
    final token = await TokenService.getToken();

    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        jobId: jobId,
      };

      final uri = Uri.parse(
        '$baseUrl/jobs/$jobId/applicants',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
        '📥 Get Applicants Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse['applications'] ?? [];
        return jsonList.map((e) => ApplicationModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch applicants: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting applicants: $e');
      throw Exception('Error getting applicants: $e');
    }
  }

  Future<bool> updateApplicationStatus(
    String applicationId,
    String newStatus,
  ) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/jobs/applications/$applicationId/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': newStatus}),
      );

      print('📤 Status Update: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Failed to update status: $e');
      return false;
    }
  }

  Future<bool> saveJob(String jobId) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/jobs/$jobId/save'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(' Save Job Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('❌ Failed to save job. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception during saveJob: $e');
      return false;
    }
  }

  Future<bool> unsaveJob(String jobId) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/jobs/$jobId/unsave'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Unsave Job Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('❌ Failed to unsave job. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception during unsaveJob: $e');
      return false;
    }
  }
}
