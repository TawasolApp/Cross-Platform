// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;
  final baseUrl = 'https://tawasolapp.me/api/';
  final String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2N2YyZWExMzBjZmJkYjVlMTlkYjFiYzYiLCJlbWFpbCI6ImZsb3lfaHlhdHQ2QGhvdG1haWwuY29tIiwicm9sZSI6ImN1c3RvbWVyIiwiaWF0IjoxNzQ0MDA0NDI5LCJleHAiOjE3NDQwMDgwMjl9._o52vTj7hN6o8q2hEKVax6OjNYE6bi_nNFjZ8McRRgI";

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

  ///////////////////remove connection
  Future<bool> removeConnection(String userId, String? token) async {
    try {
      final checkResponse = await client
          .get(
            Uri.parse('${baseUrl}list?userId=$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => http.Response('Request Timeout', 408),
          );

      if (checkResponse.statusCode == 404 || checkResponse.body.isEmpty) {
        return false;
      }

      final connections = jsonDecode(checkResponse.body);

      if (connections.isEmpty) return false;

      for (var connection in connections) {
        final connectionId = connection['id'];
        final response = await client.delete(
          Uri.parse('${baseUrl}list/$connectionId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception(
            'Failed to remove connection (ID: $connectionId), Status Code: ${response.statusCode}',
          );
        }
      }

      return true;
    } catch (e) {
      print('Error removing connection: $e');
      return false;
    }
  }

  ///////////////////Accept connection Request
  Future<bool> acceptConnectionRequest(String userId, String? token) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"isAccept": true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to accept connection request, Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error accepting connection request: $e');
      return false;
    }
  }

  ///////////////////Reject connection Request
  Future<bool> ignoreConnectionRequest(String userId, String? token) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}connections/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"isAccept": false}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to reject connection request, Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error rejecting connection request: $e');
      return false;
    }
  }

  ///////////////////Send connection Request
  Future<bool> sendConnectionRequest(String userId, String? token) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}connections/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
          'Failed to send connection request, Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error sending connection request: $e');
      return false;
    }
  }
}
