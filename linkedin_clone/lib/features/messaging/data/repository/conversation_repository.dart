import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();
  Future<List<MessageEntity>> getChat(String conversationId);
}
