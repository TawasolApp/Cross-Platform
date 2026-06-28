import 'package:linkedin_clone/features/messaging/data/repository/conversation_repository.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

class GetChatUseCase {
  final ConversationRepository repository;
  GetChatUseCase(this.repository);

  Future<List<MessageEntity>> call(String conversationId) {
    return repository.getChat(conversationId);
  }
}
