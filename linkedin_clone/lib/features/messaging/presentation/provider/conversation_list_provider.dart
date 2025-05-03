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
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
