import 'package:linkedin_clone/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/data/data_sources/mock_conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/data/repository/conversation_repository.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource ;

  ConversationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MessageEntity>> getChat(String conversationId) {
    return remoteDataSource.getChat(conversationId);
  }

  @override
  Future<List<ConversationEntity>> fetchConversations() {
    return remoteDataSource.fetchConversations();
  }
}
