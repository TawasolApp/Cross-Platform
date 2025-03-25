import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Models/user_model.dart';
import 'dart:convert';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/login'),
      body: {
        "email": email, 
        "password": password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Invalid credentials");
    }
  }


  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/forgot-password'),
      body: {
        "email": email},
    );

    if (response.statusCode == 200) {
     print("Password reset link sent to your email");
    } else {
      throw Exception("Failed to reset password");
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/forgot-password'),
      body: {
        "email": email},
    );

    if (response.statusCode == 200) {
     print("Email resent succesfully");
    } else {
      throw Exception("Failed to reset password");
    }
  }

  Future<void> loginWithGoogle(String idToken) async {
  final response = await http.post(
    Uri.parse('/auth/social-login/google'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({"idToken": idToken}),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final accessToken = json['token'];
    final refreshToken = json['refreshToken'];

    await TokenService.saveToken(accessToken);
    //await TokenService.saveRefreshToken(refreshToken);
  } else {
    throw Exception('Google login failed');
  }
}

  @override
    @override
  Future<UserModel> register(String firstName,String lastName,String email, String password, String recaptchaToken) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/register'),
      body: {
        "email": email, "password": password, "recaptchaToken": recaptchaToken},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to register");
    }
  }


}