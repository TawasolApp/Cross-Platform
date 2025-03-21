import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';
import 'profile_data_source.dart';

class ProfileRemoteDataSource implements ProfileDataSource {
  final String baseUrl;

  ProfileRemoteDataSource({required this.baseUrl});

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/profile/$userId'));

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/${profile.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
