import '../../repository/connections_repository.dart';
import '../../entities/connections_user_entity.dart';

class GetSentConnectionRequestsUseCase {
  final ConnectionsRepository repository;

  GetSentConnectionRequestsUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      return await repository.getSentConnectionRequestsList(
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }
}
