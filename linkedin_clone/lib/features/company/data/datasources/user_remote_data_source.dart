import 'dart:async';
import 'package:linkedin_clone/features/company/data/models/add_admin_request_model%20.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';

class UserRemoteDataSource {
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

  Future<bool> checkIfUserFollowsCompany(
    String userId,
    String companyId,
  ) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

    // TODO: Replace with actual API call when backend is ready
    return true; // Mocked response: always returns true (user follows the company)
  }

  Future<bool> toggleFollowCompany(
    String userId,
    String companyId,
    bool isFollowing,
  ) async {
    //TODO: Implement the actual API call to toggle follow status depending on the isfollowing
    try {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

      // Simulating toggling follow status
      bool updatedStatus = !isFollowing;

      print(
        "User $userId ${updatedStatus ? 'followed' : 'unfollowed'} company $companyId",
      );

      return updatedStatus; // Return the new status
    } catch (e) {
      print("Error toggling follow status: $e");
      return isFollowing; // Return old status on error
    }
  }

  @override
  Future<void> addAdminUser(AddAdminRequestModel user) async {
    //TODO: Post Api Request
    // final response = await client.post(
    //   Uri.parse('https://yourapi.com/admin/add'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(model.toJson()),
    // );

    // if (response.statusCode != 200) {
    //   throw Exception('Failed to add admin');
    // }
    print('Admin with id:${user.newUserId} is added');
  }
}
