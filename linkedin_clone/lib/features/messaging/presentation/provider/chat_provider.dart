import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/messaging/data/models/message_model.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/usecases/get_chat_use_case.dart';
import 'package:linkedin_clone/core/services/messaging_socket_service.dart';
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  final GetChatUseCase getChatUseCase;
  final MessagingSocketService _socketService = MessagingSocketService();

  List<MessageEntity> messages = [];
  bool isLoading = false;
  String conversationId = '';
  String userName = '';
  String userImage = '';
  String currentUserId = '';

  ChatProvider(this.getChatUseCase);

  // Setters
  void setConversationId(String id) {
    conversationId = id;
    notifyListeners();
  }

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setUserImage(String url) {
    userImage = url;
    notifyListeners();
  }

  void setCurrentUserId(String id) {
    currentUserId = id;
  }

  // Getters
  String get getUserName => userName;
  String get getConversationId => conversationId;

  // Message Fetching
  Future<void> fetchMessages(String conversationId) async {
    isLoading = true;
    notifyListeners();
    try {
      messages = await getChatUseCase.call(conversationId);
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Real-Time Init
  void initSocket(String userId, String conversationId) {
    currentUserId = userId;

    _socketService.connect(userId);
    _socketService.listenToMessages((data) {
      final msg = MessageModel.fromJson(jsonDecode(data));
      messages.insert(0, msg);
      notifyListeners();
    });
    _socketService.markMessagesRead(conversationId);
  }

  void disposeSocket() {
    _socketService.disconnect();
  }

  void sendTextMessage(String recipientId, String text) {
    print('Sending message: $text to $recipientId');
    _socketService.sendMessage({
      'receiverId': recipientId,
      'text': text,

      
    });
  }

  void sendTyping(String receiverId) {
    _socketService.sendTyping({'receiverId': receiverId});
  }
}
