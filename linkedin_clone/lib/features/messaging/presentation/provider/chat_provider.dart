import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/usecases/get_chat_use_case.dart';

class ChatProvider with ChangeNotifier {
  final GetChatUseCase getChatUseCase;

  List<MessageEntity> messages = [];
  bool isLoading = false;
  String conversationId = '';
  String userName = '';
  String userImage = '';

  ChatProvider(this.getChatUseCase);
   void setconversationId(String id) {
    conversationId = id;
    notifyListeners();
  }
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  String get getUserName => userName;
  String get getConversationId => conversationId;

  Future<void> fetchMessages(String conversationId) async {
    isLoading = true;
    notifyListeners();
    try {
      messages = await getChatUseCase.call(conversationId);
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
