import '../repository/connections_repository.dart';
import '../entities/connections_user_entity.dart';

class GetBlockedListUseCase {
  final ConnectionsRepository repository;

  GetBlockedListUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      return await repository.getBlockedList(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }
}
