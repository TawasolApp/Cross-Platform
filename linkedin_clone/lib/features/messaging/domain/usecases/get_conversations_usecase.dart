import '../entities/conversation_entity.dart';
import '../../data/data_sources/conversation_remote_data_source.dart';

class GetConversationsUseCase {
  final ConversationRemoteDataSource remoteDataSource;

  GetConversationsUseCase(this.remoteDataSource);

  Future<List<ConversationEntity>> call() async {
    return await remoteDataSource.fetchConversations();
  }
}
