import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthRemoteDataSource {

  
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/login'),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<UserModel> register(String email, String password, String recaptchaToken) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/register'),
      body: {"email": email, "password": password, "recaptchaToken": recaptchaToken},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to register");
    }
  }



}