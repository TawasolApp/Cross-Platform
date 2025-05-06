import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/messaging/data/models/message_model.dart';
import '../models/conversation_model.dart';

class ConversationRemoteDataSource {

  Future<List<ConversationModel>> fetchConversations() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('https://tawasolapp.me/api/messages/conversations'),
      headers: {
        'Authorization': 'Bearer $token', // Replace with your token fetching
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      print("conversations fetched");
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((item) => ConversationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }
  Future<List<MessageModel>> getChat(String conversationId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('https://tawasolapp.me/api/messages/conversations/$conversationId'),
      headers: {
        'Authorization': 'Bearer $token', // Replace with your token fetching
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((item) => MessageModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }
}
