import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Models/user_model.dart';
import 'dart:convert';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Helper function to get headers with authorization
  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenService.getToken(); 
    print("TOKEN AHO $token******8");// Replace with actual token retrieval logic
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://tawasolapp.me/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      print(UserModel.fromJson(json.decode(response.body)).token);
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Invalid credentials: ${response.body}");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('https://tawasolapp.me/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      print("Password reset link sent to your email");
    } else {
      throw Exception("Failed to reset password: ${response.body}");
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse('https://tawasolapp.me/api/auth/resend-confirmation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      print("Email resent successfully");
    } else {
      throw Exception("Failed to resend verification email: ${response.body}");
    }
  }

  @override
  Future<void> loginWithGoogle(String idToken) async {
    final response = await http.post(
      Uri.parse('https://tawasolapp.me/api/auth/social-login/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"idToken": idToken}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final accessToken = json['token'];
      final refreshToken = json['refreshToken'];

      await TokenService.saveToken(accessToken);
      await TokenService.saveRefreshToken(refreshToken);
    } else {
      throw Exception('Google login failed: ${response.body}');
    }
  }

  @override
  Future<UserModel> register(String firstName, String lastName, String email, String password, String captchaToken) async {
    final response = await http.post(
      Uri.parse('https://tawasolapp.me/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "captchaToken": captchaToken,
      }),
    );
    UserModel userModel = new UserModel(token: "test-token");
    if (response.statusCode == 201) {
      print("[SUCCESS] Registration successful: ${response.body}");
      return userModel;
    } else {
      print("[ERROR] Registration failed with status code ${response.statusCode}: ${response.body}");
      throw Exception("Failed to register: ${response.body}");
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    print("Current Password: $currentPassword");
    print("New Password: $newPassword");
    final response = await http.patch(
      Uri.parse('https://tawasolapp.me/api/users/update-password'),
      headers: await _getHeaders(),
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print("Password changed successfully");
    } else {
      print("Failed to change password: ${response.body}");
      throw Exception("Failed to change password: ${response.body}");
    }
  }

  @override
  Future<void> updateEmail(String newEmail, String password) async {
    String? token = await TokenService.getToken();
    print("TOKEN NAFSO AHO   $token");
    print("NEW EMAIL AHO  $newEmail");
    
    final headers = await _getHeaders();
    print("HEADERS AHO   $headers");
    final response = await http.patch(
      Uri.parse('https://tawasolapp.me/api/users/request-email-update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "newEmail": newEmail,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Email changed successfully");
    } else {
      print("Failed to change email: ${response.body}");
      throw Exception("Failed to update email: ${response.body}");
    }
  }

  @override
  Future<void> deleteAccount(String email, String password) async {
    print("Email: $email");
    print("Password: $password");
    print("Deleting account...");
    final response = await http.delete(
      Uri.parse('https://tawasolapp.me/api/users/delete-account'),
      headers: await _getHeaders(),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Account deleted successfully");
    } else {
      print("Failed to delete account: ${response.body}");
      throw Exception("Failed to delete account: ${response.body}");
    }
  }
}
