import 'package:flutter/material.dart';
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
      conversations = await getConversationsUseCase();
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
