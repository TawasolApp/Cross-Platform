import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:linkedin_clone/features/connections/data/models/connections_list_user_model.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';

class ConnectionsRemoteDataSource {
  final http.Client client;
  final baseUrl = 'http://192.168.1.9:3000/';
  final List<Map<String, dynamic>> _mockConnectionsData = [
    {
      "userId": "1",
      "username": "Alice Johnson",
      "profilePicture": "https://randomuser.me/api/portraits/men/1.jpg",
      "headline": "Software Engineer",
      "createdAt": "2025-03-23T12:00:00Z",
    },
    {
      "userId": "2",
      "username": "Bob Smith",
      "profilePicture": "https://randomuser.me/api/portraits/men/2.jpg",
      "headline": "Data Scientist",
      "createdAt": "2025-03-25T14:00:00Z",
    },
    {
      "userId": "3",
      "username": "Charlie Brown",
      "profilePicture": "https://randomuser.me/api/portraits/men/3.jpg",
      "headline": "Product Manager",
      "createdAt": "2025-03-26T10:00:00Z",
    },
    {
      "userId": "4",
      "username": "Diana Prince",
      "profilePicture": "https://randomuser.me/api/portraits/men/4.jpg",
      "headline": "UX Designer",
      "createdAt": "2025-03-27T09:00:00Z",
    },
    {
      "userId": "5",
      "username": "Ethan Hunt",
      "profilePicture": "https://randomuser.me/api/portraits/men/5.jpg",
      "headline": "Marketing Specialist",
      "createdAt": "2025-02-28T08:00:00Z",
    },
    {
      "userId": "6",
      "username": "Fiona Gallagher",
      "profilePicture": "https://randomuser.me/api/portraits/men/6.jpg",
      "headline": "HR Manager",
      "createdAt": "2024-03-29T07:00:00Z",
    },
    {
      "userId": "7",
      "username": "George Clooney",
      "profilePicture": "https://randomuser.me/api/portraits/men/7.jpg",
      "headline": "Actor",
      "createdAt": "2025-03-30T06:00:00Z",
    },
    {
      "userId": "8",
      "username": "Hannah Montana",
      "profilePicture": "https://randomuser.me/api/portraits/men/8.jpg",
      "headline": "Singer",
      "createdAt": "2025-03-31T05:00:00Z",
    },
    {
      "userId": "9",
      "username": "Ian Somerhalder",
      "profilePicture": "https://randomuser.me/api/portraits/men/9.jpg",
      "headline": "Model",
      "createdAt": "2025-04-01T04:00:00Z",
    },
    {
      "userId": "10",
      "username": "Jessica Alba",
      "profilePicture": "https://randomuser.me/api/portraits/men/10.jpg",
      "headline": "Entrepreneur",
      "createdAt": "2025-04-02T03:00:00Z",
    },
    {
      "userId": "11",
      "username": "Kevin Hart",
      "profilePicture": "https://randomuser.me/api/portraits/men/11.jpg",
      "headline": "Comedian",
      "createdAt": "2025-04-03T02:00:00Z",
    },
    {
      "userId": "12",
      "username": "Liam Neeson",
      "profilePicture": "https://randomuser.me/api/portraits/men/12.jpg",
      "headline": "Actor",
      "createdAt": "2025-04-04T01:00:00Z",
    },
    {
      "userId": "13",
      "username": "Mila Kunis",
      "profilePicture": "https://randomuser.me/api/portraits/men/13.jpg",
      "headline": "Actress",
      "createdAt": "2025-04-05T00:00:00Z",
    },
    {
      "userId": "14",
      "username": "Nathan Drake",
      "profilePicture": "https://randomuser.me/api/portraits/men/14.jpg",
      "headline": "Adventurer",
      "createdAt": "2025-04-06T23:00:00Z",
    },
    {
      "userId": "15",
      "username": "Olivia Wilde",
      "profilePicture": "https://randomuser.me/api/portraits/men/15.jpg",
      "headline": "Director",
      "createdAt": "2025-04-07T22:00:00Z",
    },
    {
      "userId": "16",
      "username": "Peter Parker",
      "profilePicture": "https://randomuser.me/api/portraits/men/16.jpg",
      "headline": "Photographer",
      "createdAt": "2025-04-08T21:00:00Z",
    },
    {
      "userId": "17",
      "username": "Quentin Tarantino",
      "profilePicture": "https://randomuser.me/api/portraits/men/17.jpg",
      "headline": "Filmmaker",
      "createdAt": "2025-04-09T20:00:00Z",
    },
    {
      "userId": "18",
      "username": "Rachel Green",
      "profilePicture": "https://randomuser.me/api/portraits/men/18.jpg",
      "headline": "Fashion Designer",
      "createdAt": "2025-04-10T19:00:00Z",
    },
    {
      "userId": "19",
      "username": "Steve Jobs",
      "profilePicture": "https://randomuser.me/api/portraits/men/19.jpg",
      "headline": "Visionary",
      "createdAt": "2021-04-11T18:00:00Z",
    },
    {
      "userId": "20",
      "username": "Tony Stark",
      "profilePicture": "https://randomuser.me/api/portraits/men/20.jpg",
      "headline": "Engineer",
      "createdAt": "2024-09-12T17:00:00Z",
    },
    {
      "userId": "21",
      "username": "Uma Thurman",
      "profilePicture": "https://randomuser.me/api/portraits/men/21.jpg",
      "headline": "Actress",
      "createdAt": "2025-04-13T16:00:00Z",
    },
    {
      "userId": "22",
      "username": "Vin Diesel",
      "profilePicture": "https://randomuser.me/api/portraits/men/22.jpg",
      "headline": "Actor",
      "createdAt": "2013-07-26T15:00:00Z",
    },
  ];
  ConnectionsRemoteDataSource({required this.client});

  ///////////////////Get connections list
  Future<List<ConnectionsListUserEntity>> getConnectionsList(
    String? token,
  ) async {
    ///////Note: API calles are commented for ease of testing without a mock server, they're replaced with mock data
    //////API calls have been tested using mock server and Postman
    ///////Uncomment the API calls and comment the mock data to test with a real server
    ///////Also, make sure to replace the baseUrl with the actual server URL

    // final response = await client
    //     .get(
    //       Uri.parse('${baseUrl}connections'),
    //       headers: {
    //         'Content-Type': 'application/json',
    //         'Authorization': 'Bearer $token',
    //       },
    //     )
    //     .timeout(
    //       Duration(seconds: 15),
    //       onTimeout: () {
    //         return http.Response('Request Timeout', 408);
    //       },
    //     );

    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);
    //   if (jsonResponse is Map<String, dynamic> &&
    //       jsonResponse.containsKey('connections')) {
    //     final List<dynamic> connectionsJson = jsonResponse['connections'];
    //     return connectionsJson
    //             .map((json) => ConnectionsListUserModel.fromJson(json))
    //             .toList() ??
    //         [];
    //   } else if (jsonResponse is List<dynamic>) {
    //     return jsonResponse
    //             .map((json) => ConnectionsListUserModel.fromJson(json))
    //             .toList() ??
    //         [];
    //   } else {
    //     throw Exception(
    //       'Invalid JSON structure: Expected a list or an object with "connections" key.',
    //     );
    //   }
    // } else {
    //   throw Exception(
    //     'Failed to load connections, Status Code: ${response.statusCode}',
    //   );

    print(
      _mockConnectionsData
          .map((json) => ConnectionsListUserModel.fromJson(json))
          .toList(),
    );

    return _mockConnectionsData
        .map((json) => ConnectionsListUserModel.fromJson(json))
        .toList();
  }

  ///////////////////remove connection

  Future<bool> removeConnection(String userId, String? token) async {
    ///////Note: API calles are commented for ease of testing without a mock server, they're replaced with mock data
    //////API calls have been tested using mock server and Postman
    ///////Uncomment the API calls and comment the mock data to test with a real server
    ///////Also, make sure to replace the baseUrl with the actual server URL
    ///
    //   final checkResponse = await client
    //       .get(
    //         Uri.parse('${baseUrl}connections?userId=$userId'),
    //         headers: {
    //           'Content-Type': 'application/json',
    //           'Authorization': 'Bearer $token',
    //         },
    //       )
    //       .timeout(
    //         Duration(seconds: 15),
    //         onTimeout: () {
    //           return http.Response('Request Timeout', 408);
    //         },
    //       );
    //   if (checkResponse.statusCode == 404) {
    //     return false;
    //   }

    //   final response = await client
    //       .delete(
    //         Uri.parse('${baseUrl}connections?userId=$userId'),
    //         headers: {
    //           'Content-Type': 'application/json',
    //           'Authorization': 'Bearer $token',
    //         },
    //       )
    //       .timeout(
    //         Duration(seconds: 15),
    //         onTimeout: () {
    //           throw Exception('Request Timed Out');
    //         },
    //       );

    //   if (response.statusCode == 200 || response.statusCode == 204) {
    //     return true;
    //   } else {
    //     throw Exception(
    //       'Failed to remove connection, Status Code: ${response.statusCode}',
    //     );
    //   }
    // }

    final index = _mockConnectionsData.indexWhere(
      (connection) => connection['userId'] == userId,
    );
    if (index != -1) {
      _mockConnectionsData.removeAt(index);
      return true;
    } else {
      print('Connection not found');
      return false;
    }
  }
}
