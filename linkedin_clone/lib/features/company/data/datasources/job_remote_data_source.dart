import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/data/models/create_job_model.dart';
import '../models/job_model.dart';

class JobRemoteDataSource {
  final String baseUrl = "https://tawasolapp.me/api";
  Future<List<JobModel>> getRecentJobs(String companyId) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/companies/$companyId/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('CHECK THIS: ${jsonList.map((json) => JobModel.fromJson(json)).toList()}');
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
}
