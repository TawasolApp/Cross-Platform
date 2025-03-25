import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_list_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;

  ConnectionsRemoteDataSource({required this.client});

  ///////////////////Get connections list
  Future<List<ConnectionsListUserEntity>> getConnectionsList() async {
    final response = await client
        .get(
          Uri.parse('http://192.168.1.9:3000/connections'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Request Timed Out');
          },
        );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('connections')) {
        final List<dynamic> connectionsJson = jsonResponse['connections'];
        return connectionsJson
                .map((json) => ConnectionsListUserModel.fromJson(json))
                .toList() ??
            [];
      } else if (jsonResponse is List<dynamic>) {
        print("JSON Response: $jsonResponse");
        return jsonResponse
                .map((json) => ConnectionsListUserModel.fromJson(json))
                .toList() ??
            [];
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

  Future<bool> removeConnection(String userId) async {
    print("Removing connection for user ID: $userId");
    print("API URL: http://192.168.1.9:3000/connections?userId=$userId");

    final checkResponse = await client.get(
      Uri.parse('http://192.168.1.9:3000/connections?userId=$userId'),
    );
    if (checkResponse.statusCode == 404) {
      print("User not found.");
      return false;
    }

    final response = await client
        .delete(
          Uri.parse('http://192.168.1.9:3000/connections?userId=$userId'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Request Timed Out');
          },
        );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        'Failed to remove connection, Status Code: ${response.statusCode}',
      );
    }
  }
}
