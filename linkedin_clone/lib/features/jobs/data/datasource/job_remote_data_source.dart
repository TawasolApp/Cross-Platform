import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
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
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (location != null && location.isNotEmpty) 'location': location,
      if (industry != null && industry.isNotEmpty) 'industry': industry,
      if (experienceLevel != null && experienceLevel.isNotEmpty)
        'experienceLevel': experienceLevel,
      if (company != null && company.isNotEmpty) 'company': company,
      if (minSalary != null) 'minSalary': minSalary.toString(),
      if (maxSalary != null) 'maxSalary': maxSalary.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/jobs?page=$page&limit=$limit',
    ).replace(queryParameters: queryParams);
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
        final List<dynamic> jsonList = json.decode(response.body);
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

  // final response = await http.post(
  //   Uri.parse('https://tawasolapp.me/api/jobs/${application.jobId}/apply'),
  //   headers: {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   },
  //   body: jsonEncode({
  //     "jobId": application.jobId,
  //     "phoneNumber": application.phoneNumber,
  //     "resumeURL": application.resumeURL,
  //   }),
  // );

  // return response.statusCode == 200 || response.statusCode == 201;
  return true; 
}

}
