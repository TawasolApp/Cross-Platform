import '../repository/connections_repository.dart';
import '../entities/connections_user_entity.dart';

class GetConnectionsUseCase {
  final ConnectionsRepository repository;

  GetConnectionsUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call({
    int page = 0,
    int limit = 0,
    int sortBy = 1,
  }) async {
    try {
      return await repository.getConnectionsList(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
    } catch (e) {
      rethrow;
    }
  }
}
