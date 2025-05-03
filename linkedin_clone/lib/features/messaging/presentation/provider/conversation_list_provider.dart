import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/usecases/get_chat_use_case.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/get_conversations_usecase.dart';

class ConversationListProvider with ChangeNotifier {
  final GetConversationsUseCase getConversationsUseCase;

  


  List<ConversationEntity> conversations = [];
  
  bool isLoading = false;


  ConversationListProvider(this.getConversationsUseCase);

  Future<void> fetchConversations() async {
    isLoading = true;
    notifyListeners();
    try {
      conversations = await getConversationsUseCase.call();
      print('Conversations loaded: ${conversations.length}');
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void markConversationAsRead(String conversationId) {
  final index = conversations.indexWhere((c) => c.id == conversationId);
  if (index != -1) {
    conversations[index].unseenCount = 0;
    notifyListeners();
  }
}

void markConversationAsUnread(String conversationId) {
  final index = conversations.indexWhere((c) => c.id == conversationId);
  if (index != -1) {
    conversations[index].unseenCount = 1; // or any number you want
    notifyListeners();
  }
}

ConversationEntity? getConversationById(String conversationId) {
  try {
    return conversations.firstWhere((c) => c.id == conversationId);
  } catch (e) {
    return null;
  }
}

}
