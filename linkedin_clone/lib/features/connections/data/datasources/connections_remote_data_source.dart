// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_user_model.dart';
import 'package:linkedin_clone/features/connections/data/models/people_you_may_know_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/core/services/token_service.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://tawasolapp.me/api/';

  ConnectionsRemoteDataSource({required this.client});

  Future<String> initToken() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  ///////////////////Get connections list
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    String? userId,
    int page = 0,
    int limit = 0,
    int sortBy = 1,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/$userId/list?page=$page&limit=$limit&by=$sortBy&direction=1',
            ),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getConnectionsList: 500 ',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getConnectionsList: 401 Authentication failed",
        );
      } else {
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getConnectionsList: ${e.toString()}\n',
      );
      rethrow;
    }
  }

  ///////////////////Get received connections list
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      print('page: $page');
      print('limit: $limit');
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse('${baseUrl}connections/pending?page=$page&limit=$limit'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Request Timeout');
            },
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getReceivedConnectionRequestsList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getReceivedConnectionRequestsList: 401 Authentication failed",
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getReceivedConnectionRequestsList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getReceivedConnectionRequestsList: ${e.toString()}\n',
      );
      rethrow;
    }
  }

  ///////////////////Get sent connections list
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse('${baseUrl}connections/sent/?page=$page&limit=$limit'),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource : getSentConnectionRequestsList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getSentConnectionRequestsList: 401 Authentication failed",
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getSentConnectionRequestsList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getSentConnectionRequestsList: ${e.toString()}\n',
      );
      rethrow;
    }
  }

  ///////////////////Get followers list
  Future<List<ConnectionsUserEntity>> getFollowersList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/followers?page=$page&limit=$limit',
            ),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('jsonResponse: $jsonResponse');
        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getFollowersList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getFollowersList: 401 Authentication failed",
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getFollowersList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getFollowersList: ${e.toString()}\n',
      );
      rethrow;
    }
  }

  ///////////////////Get following list
  Future<List<ConnectionsUserEntity>> getFollowingList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/following?page=$page&limit=$limit',
            ),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getFollowingList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getFollowingList: 401 Authentication failed",
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getFollowingList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getFollowingList: ${e.toString()}\n',
      );
      rethrow;
    }
  }

  ///////////////////Get blocked list
  Future<List<ConnectionsUserEntity>> getBlockedList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse('${baseUrl}connections/blocked?page=$page&limit=$limit'),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => ConnectionsUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getBlockedList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getBlockedList: 401 Authentication failed",
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getBlockedList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      print('\nConnectionsRemoteDataSource :getBlockedList: ${e.toString()}\n');
      rethrow;
    }
  }

  ///////////////////remove connection
  Future<bool> removeConnection(String userId) async {
    try {
      final token = await initToken();
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :removeConnection: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :removeConnection: 500 Failed",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :removeConnection: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :removeConnection: 401 Authentication failed",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :removeConnection: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :removeConnection: ${e.toString()}\n',
      );
      return false;
    }
  }

  ///////////////////Accept or Ignore connection Request
  Future<bool> acceptIgnoreConnectionRequest(String userId, bool accept) async {
    print('userId: $userId');
    try {
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({"isAccept": accept}),
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 500 Failed",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 401 Authentication failed",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :acceptConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :acceptIgnoreConnectionRequest: ${e.toString()}\n',
      );
      return false;
    }
  }

  ///////////////////Send connection Request
  Future<bool> sendConnectionRequest(String userId) async {
    print('userId: $userId');
    try {
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}connections'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId}),
      );
      print('response: ${response.body}');
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :remosendConnectionRequestveConnection: 500 Failed",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 401 Authentication failed",
        );
      } else if (response.statusCode == 409) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 409 already exists",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :sendConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :sendConnectionRequest: ${e.toString()}\n',
      );
      return false;
    }
  }
  ///////////////////withdraw connection Request

  Future<bool> withdrawConnectionRequest(String userId) async {
    try {
      final token = await initToken();
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/$userId/pending'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 500 Failed",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 401 Authentication failed",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :withdrawConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :withdrawConnectionRequest: ${e.toString()}\n',
      );
      return false;
    }
  }

  ////////unfollow user
  Future<bool> unfollowUser(String userId) async {
    try {
      final token = await initToken();
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/unfollow/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :unfollowUser: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :unfollowUser: 500 Failed",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :unfollowUser: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :unfollowUser: 401 Authentication failed",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :unfollowUser: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nConnectionsRemoteDataSource :unfollowUser: ${e.toString()}\n');
      return false;
    }
  }

  ////////follow user
  Future<bool> followUser(String userId) async {
    try {
      final token = await initToken();
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/follow'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :followUser: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception("ConnectionsRemoteDataSource :followUser: 500 Failed");
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :followUser: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :followUser: 401 Authentication failed",
        );
      } else if (response.statusCode == 409) {
        throw Exception(
          "ConnectionsRemoteDataSource :followUser: 409 already exists",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :followUser: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nConnectionsRemoteDataSource :followUser: ${e.toString()}\n');
      return false;
    }
  }

  ///////////////////block user
  Future<bool> blockUser(String userId) async {
    try {
      final token = await initToken();
      final response = await client.post(
        Uri.parse('${baseUrl}connections/block/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :blockUser: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception("ConnectionsRemoteDataSource :blockUser: 500 Failed");
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :blockUser: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :blockUser: 401 Authentication failed",
        );
      } else {
        print('ConnectionsRemoteDataSource :blockUser: ${response.statusCode}');
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nConnectionsRemoteDataSource :blockUser: ${e.toString()}\n');
      return false;
    }
  }

  ///////////////////unblock user
  Future<bool> unblockUser(String userId) async {
    try {
      final token = await initToken();
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/block/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :unblockUser: 400 invalid input",
        );
      } else if (response.statusCode == 500) {
        throw Exception("ConnectionsRemoteDataSource :unblockUser: 500 Failed");
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :unblockUser: 404 not found",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :unblockUser: 401 Authentication failed",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :unblockUser: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print('\nConnectionsRemoteDataSource :unblockUser: ${e.toString()}\n');
      return false;
    }
  }

  Future<List<PeopleYouMayKnowUserModel>> getPeopleYouMayKnowList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final token = await initToken();
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/recommended?page=$page&limit=$limit',
            ),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List<dynamic>) {
          return jsonResponse
              .map((json) => PeopleYouMayKnowUserModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
          'ConnectionsRemoteDataSource :getPeopleYouMayKnowList: 500 Failed',
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :getPeopleYouMayKnowList: 401 Authentication failed",
        );
      } else {
        throw Exception('Unknown error ${response.statusCode}');
      }
    } catch (e) {
      print(
        '\nConnectionsRemoteDataSource :getPeopleYouMayKnowList: ${e.toString()}\n',
      );
      rethrow;
    }
  }
}
