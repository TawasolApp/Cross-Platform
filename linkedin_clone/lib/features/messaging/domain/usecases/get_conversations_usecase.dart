import 'package:linkedin_clone/features/messaging/data/repository/conversation_repository.dart';

import '../entities/conversation_entity.dart';
import '../../data/data_sources/conversation_remote_data_source.dart';

class GetConversationsUseCase {
  final ConversationRepository repository;
  GetConversationsUseCase(this.repository);

  Future<List<ConversationEntity>> call() async {
    return await repository.fetchConversations();
  }
}
