

import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Models/user_model.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake credential check here
    if (email == "test@example.com" && password == "123456") {
      return UserModel(
        token: 'mock_token_abc',
      );
    } else {
      throw Exception("Invalid credentials");
    }
  }

  @override
  Future<UserModel> register(String firstName,String lastName,String email, String password, String recaptchaToken) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake registration logic here
    if (email == "test@example.com" && password == "123456" && recaptchaToken == "mock-captcha-token") {
      print("User registered successfully");
      return UserModel(
      token: 'new_mock_token_xyz',
      );
    } 
    else {
      throw Exception("Invalid registration details");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake password reset logic here
    if (email == "test@example.com") {
      print("Password reset link sent to your email");
      return;
    } else {
      throw Exception("Failed to reset password");
    }
  }

    @override
      Future<void> resendVerificationEmail(String email) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake password reset logic here
    if (email == "test@example.com") {
      print("Password reset link sent to your email");
      return;
    } else {
      throw Exception("Email not found");
    }
  }


  Future<void> loginWithGoogle(String idToken) async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

  // Log the ID token for debug
  print("Mock Google Sign-In ID Token: $idToken");

  // Simulate success (always succeeds)
  return;
}

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount(String email, String password) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> updateEmail(String newEmail, String password) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }


}
