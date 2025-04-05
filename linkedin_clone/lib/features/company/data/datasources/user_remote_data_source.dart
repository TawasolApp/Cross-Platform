import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/data/models/add_admin_request_model%20.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';

class UserRemoteDataSource {
  final String baseUrl = "https://tawasolapp.me/api";
  Future<List<UserModel>> getUserFriends(String userId) async {
    // TODO: Replace this mock data with a real API request once Auth is available
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    return [
      UserModel(
        userId: "user1",
        username: "Alice",
        profilePicture:
            "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=612x612&w=0&k=20&c=9zbG2-9fl741fbTWw5fNgcEEe4ll-JegrGlQQ6m54rg=",
        headline: 'Software Engineer',
      ),
      UserModel(
        userId: "user2",
        username: "Bob",
        profilePicture:
            "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=612x612&w=0&k=20&c=9zbG2-9fl741fbTWw5fNgcEEe4ll-JegrGlQQ6m54rg=",
        headline: 'Software Engineer',
      ),
      UserModel(
        userId: "user3",
        username: "Charlie",
        profilePicture:
            "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=612x612&w=0&k=20&c=9zbG2-9fl741fbTWw5fNgcEEe4ll-JegrGlQQ6m54rg=",
        headline: 'Software Engineer',
      ),
    ];
  }


  Future<bool> toggleFollowCompany(
    String userId,
    String companyId,
    bool isFollowing,
  ) async {
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
          "User $userId ${newFollowStatus ? 'followed' : 'unfollowed'} company $companyId",
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

  @override
  Future<void> addAdminUser(AddAdminRequestModel user,String companyId) async {
    //TODO: Post Api Request
    final token = await TokenService.getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/companies/$companyId/admins/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Company created successfully');
        print('Response body: ${response.body}');
      } else {
        print(
          '❌ Failed to create company. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        throw Exception('Failed to create company');
      }
    } catch (e) {
      print('⚠️ Exception occurred: $e');
      throw Exception('Something went wrong while creating the company');
    }
    print('Admin with id:${user.newUserId} is added');
  }
}
