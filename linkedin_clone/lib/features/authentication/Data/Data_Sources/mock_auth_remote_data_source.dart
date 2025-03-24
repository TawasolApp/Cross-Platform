import '../models/user_model.dart';

class MockAuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake credential check here
    if (email == "test@example.com" && password == "123456") {
      return UserModel(
        id: '1',
        name: 'Mock User',
        email: email,
        password: password, 
        token: 'mock_token_abc',
      );
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<UserModel> register(String email, String password, String recaptchaToken) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // You can add fake registration logic here
    if (email == "newuser@example.com" && password == "password123" && recaptchaToken == "valid_recaptcha_token") {
      return UserModel(
      id: '2',
      name: 'New Mock User',
      email: email,
      password: password,
      token: 'new_mock_token_xyz',
      );
    } 
    else {
      throw Exception("Invalid registration details");
    }
  }
}
