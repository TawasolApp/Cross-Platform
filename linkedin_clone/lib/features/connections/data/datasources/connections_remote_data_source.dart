import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_list_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;
  final baseUrl = 'http://192.168.1.9:3000/';

  ConnectionsRemoteDataSource({required this.client});

  ///////////////////Get connections list
  Future<List<ConnectionsListUserEntity>> getConnectionsList(
    String? token,
  ) async {
    final response = await client
        .get(
          Uri.parse('${baseUrl}connections'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            return http.Response('Request Timeout', 408);
          },
        );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List<dynamic>) {
        return jsonResponse
            .map((json) => ConnectionsListUserModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Invalid JSON structure: Expected a list or an object with "connections" key.',
        );
      }
    } else {
      throw Exception(
        'Failed to load connections, Status Code: ${response.statusCode}',
      );
    }
  }

  ///////////////////remove connection
  Future<bool> removeConnection(String userId, String? token) async {
    try {
      // Fetch all connections for the given userId
      final checkResponse = await client
          .get(
            Uri.parse('${baseUrl}connections?userId=$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            Duration(seconds: 15),
            onTimeout: () => http.Response('Request Timeout', 408),
          );

      if (checkResponse.statusCode == 404 || checkResponse.body.isEmpty) {
        return false;
      }

      final connections = jsonDecode(checkResponse.body);

      if (connections.isEmpty) return false;
      // Delete each connection individually
      for (var connection in connections) {
        final connectionId = connection['id']; // Ensure the key is correct
        final response = await client.delete(
          Uri.parse('${baseUrl}connections/$connectionId'),
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
}
