// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://tawasolapp.me/api/';
  final String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2N2YyZWExMzBjZmJkYjVlMTlkYjFiYzAiLCJlbWFpbCI6Imhhbms2OEBnbWFpbC5jb20iLCJyb2xlIjoibWFuYWdlciIsImlhdCI6MTc0NDAxNDAyOSwiZXhwIjoxNzQ0MDE3NjI5fQ.k6BIAplzwsGMUiV9RoKySzcrxyiZ9HAl5fModP9_zQI";

  ConnectionsRemoteDataSource({required this.client});

  ///////////////////Get connections list
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    int page = 0,
    int limit = 0,
    int sortBy = 1,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/list?page=$page&limit=$limit&by=$sortBy&direction=1',
            ),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
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
        throw Exception('ConnectionsRemoteDataSource :getConnectionsList: 500');
      } else {
        print(
          '\nConnectionsRemoteDataSource :getConnectionsList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///////////////////Get received connections list
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      print('page: $page, limit: $limit');
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/pending?page=$page&limit=$limit&by=1&direction=1',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
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
          'ConnectionsRemoteDataSource :getReceivedConnectionRequestsList: 500',
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getReceivedConnectionRequestsList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///////////////////Get sent connections list
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/sent/?page=$page&limit=$limit&by=1&direction=1',
            ),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
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
          'ConnectionsRemoteDataSource : getSentConnectionRequestsList: 500',
        );
      } else {
        print(
          '\nConnectionsRemoteDataSource :getSentConnectionRequestsList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///////////////////Get followers list
  Future<List<ConnectionsUserEntity>> getFollowersList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/followers?page=$page&limit=$limit&by=1&direction=1',
            ),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
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
        throw Exception('ConnectionsRemoteDataSource :getFollowersList: 500');
      } else {
        print(
          '\nConnectionsRemoteDataSource :getFollowersList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///////////////////Get following list
  Future<List<ConnectionsUserEntity>> getFollowingList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${baseUrl}connections/following?page=$page&limit=$limit&by=1&direction=1',
            ),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
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
        throw Exception('ConnectionsRemoteDataSource :getFollowingList: 500');
      } else {
        print(
          '\nConnectionsRemoteDataSource :getFollowingList: ${response.statusCode}\n',
        );
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///////////////////remove connection
  Future<bool> removeConnection(String userId) async {
    try {
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({"isAccept": true}),
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception("ConnectionsRemoteDataSource :removeConnection: 400");
      } else if (response.statusCode == 500) {
        throw Exception("ConnectionsRemoteDataSource :removeConnection: 500");
      } else if (response.statusCode == 404) {
        throw Exception("ConnectionsRemoteDataSource :removeConnection: 404");
      } else if (response.statusCode == 401) {
        throw Exception("ConnectionsRemoteDataSource :removeConnection: 401");
      } else {
        print(
          'ConnectionsRemoteDataSource :acceptConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception("Unknown error");
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///////////////////Accept or Ignore connection Request
  Future<bool> acceptIgnoreConnectionRequest(String userId) async {
    print('userId: $userId');
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {'Authorization': 'Bearer $_token'},
        body: jsonEncode({"isAccept": true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 400",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 500",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 404",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :acceptConnectionRequest: 401",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :acceptConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception("Unknown error");
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///////////////////Send connection Request
  Future<bool> sendConnectionRequest(String userId) async {
    print('userId: $userId');
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}connections/'),
        headers: {'Authorization': 'Bearer $_token'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 400",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :remosendConnectionRequestveConnection: 500",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 404",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 401",
        );
      } else if (response.statusCode == 409) {
        throw Exception(
          "ConnectionsRemoteDataSource :sendConnectionRequest: 409",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :sendConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception("Unknown error");
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
  ///////////////////withdraw connection Request

  Future<bool> withdrawConnectionRequest(String userId) async {
    try {
      final response = await client.delete(
        Uri.parse('${baseUrl}connections/$userId/pending'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 400",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 500",
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 404",
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          "ConnectionsRemoteDataSource :withdrawConnectionRequest: 401",
        );
      } else {
        print(
          'ConnectionsRemoteDataSource :withdrawConnectionRequest: ${response.statusCode}',
        );
        // Handle other status codes as needed
        throw Exception("Unknown error");
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
