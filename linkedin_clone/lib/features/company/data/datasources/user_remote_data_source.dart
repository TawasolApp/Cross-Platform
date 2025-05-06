import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/data/models/add_admin_request_model%20.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';

class UserRemoteDataSource {
  final String baseUrl = "https://tawasolapp.me/api";

  Future<bool> toggleFollowCompany(String companyId, bool isFollowing) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    try {
      // Based on the current follow status, either follow or unfollow
      final String action = isFollowing ? 'unfollow' : 'follow';
      final Uri url = Uri.parse('$baseUrl/companies/$companyId/$action/');

      // Decide the HTTP method based on follow status
      final http.Response response;
      if (isFollowing) {
        // Use DELETE method for unfollow action
        response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Use POST method for follow action
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      print("Toggle follow response: ${response.statusCode}");
      print("Body: ${response.body}");
      print("Code: ${response.statusCode}");
      // Check the response
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully toggled the follow/unfollow status
        bool newFollowStatus = !isFollowing;
        print(
          "User ${newFollowStatus ? 'followed' : 'unfollowed'} company $companyId",
        );
        return newFollowStatus; // Return updated status
      } else {
        // In case of failure
        print("Failed to toggle follow status: ${response.body}");
        return isFollowing; // Return current status if the operation failed
      }
    } catch (e) {
      print("Error toggling follow status: $e");
      return isFollowing; // Return the current status in case of an error
    }
  }

  Future<void> addAdminUser(AddAdminRequestModel user, String companyId) async {
    //TODO: Post Api Request
    final token = await TokenService.getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/companies/$companyId/managers/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Add Admin  successfully');
        print('Response body: ${response.body}');
      } else {
        print('❌ Failed to add admin. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add admin');
      }
    } catch (e) {
      print('⚠️ Exception occurred: $e');
      throw Exception('Something went wrong while adding admin');
    }
    print('Admin with id:${user.newUserId} is added');
  }

  Future<List<UserModel>> getCommonFollowers(String companyId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/common'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Fetching common user following:');
    print('Response body for fetch common users following: ${response.body}');
    print(
      'Response status code for common users following: ${response.statusCode}',
    );
    if (response.statusCode == 200) {
      // If the server returns a successful response
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to load admins');
    }
  }

  Future<List<UserModel>> searchUsers(String query,{int page = 1,
    int limit = 3}) async {
    final token = await TokenService.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/connections/users?name=$query&page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response from search users: ${response.body}');
      print('Response status code from search users: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching users: $e');
    }
  }
}
