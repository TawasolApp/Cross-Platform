// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/privacy/data/models/privacy_user_model.dart';
import 'package:linkedin_clone/features/privacy/domain/entities/privacy_user_entity.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_enums.dart';

class PrivacyRemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://tawasolapp.me/api/';

  PrivacyRemoteDataSource({required this.client});

  Future<String> initToken() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  /////////////////// Block user
  Future<bool> blockUser(String userId) async {
    try {
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}security/block/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "PrivacyRemoteDataSource :blockUser: 400 invalid input",
        );
      } else if (response.statusCode == 404) {
        throw Exception("PrivacyRemoteDataSource :blockUser: 404 not found");
      } else {
        print('PrivacyRemoteDataSource :blockUser: ${response.statusCode}');
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :blockUser: ${e.toString()}\n');
      return false;
    }
  }

  /////////////////// Unblock user
  Future<bool> unblockUser(String userId) async {
    try {
      print("block user called with userId: $userId");
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}security/unblock/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception("PrivacyRemoteDataSource :unblockUser: 404 not found");
      } else {
        print('PrivacyRemoteDataSource :unblockUser: ${response.statusCode}');
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :unblockUser: ${e.toString()}\n');
      return false;
    }
  }

  /////////////////// Get blocked list
  Future<List<PrivacyUserEntity>> getBlockedList() async {
    try {
      print("⏲️⏲️⏲️⏲️⏲️get blocked list called");
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse('${baseUrl}security/blocked-users'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Request Timeout');
            },
          );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => PrivacyUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception('PrivacyRemoteDataSource :getBlockedList: 500 Failed');
      } else if (response.statusCode == 401) {
        throw Exception(
          "PrivacyRemoteDataSource :getBlockedList: 401 Authentication failed",
        );
      } else {
        print(
          '\nPrivacyRemoteDataSource :getBlockedList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :getBlockedList: ${e.toString()}\n');
      rethrow;
    }
  }

  ///////////////////Report user
  Future<bool> reportUser(String userId, String reason) async {
    try {
      final token = await initToken();
      print("@😭😭😭😭😭$token");
      final response = await client.post(
        Uri.parse('${baseUrl}security/report'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "reportedId": userId,
          "reportedType": "User",
          'reason': reason,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "PrivacyRemoteDataSource :reportUser: 400 invalid input",
        );
      } else if (response.statusCode == 401) {
        throw Exception("PrivacyRemoteDataSource :reportUser: 401 not found");
      } else {
        print('PrivacyRemoteDataSource :reportUser: ${response.statusCode}');
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :reportUser: ${e.toString()}\n');
      return false;
    }
  }

  Future<bool> reportPost(String postId, String reason) async {
    print(
      '😭😭😭😭😭😭😭reportPost called with postId: $postId and reason: $reason',
    );
    try {
      final token = await initToken();
      print("@😭😭😭😭😭$token");
      final response = await client.post(
        Uri.parse('${baseUrl}security/report'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "reportedId": postId,
          "reportedType": "Post",
          'reason': reason,
        }),
      );
      print('PrivacyRemoteDataSource :reportPost: ${response.statusCode}');

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "PrivacyRemoteDataSource :reportPost: 400 invalid input",
        );
      } else if (response.statusCode == 401) {
        throw Exception("PrivacyRemoteDataSource :reportPost: 401 not found");
      } else {
        print('PrivacyRemoteDataSource :reportPost: ${response.statusCode}');
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :reportPost: ${e.toString()}\n');
      return false;
    }
  }

  Future<bool> reportJob(String jobId, String reason) async {
    try {
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}security/report/job/$jobId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "PrivacyRemoteDataSource :reportJob: 400 invalid input",
        );
      } else if (response.statusCode == 401) {
        throw Exception("PrivacyRemoteDataSource :reportJob: 401 not found");
      } else {
        print('PrivacyRemoteDataSource :reportJob: ${response.statusCode}');
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nPrivacyRemoteDataSource :reportJob: ${e.toString()}\n');
      return false;
    }
  }
}
