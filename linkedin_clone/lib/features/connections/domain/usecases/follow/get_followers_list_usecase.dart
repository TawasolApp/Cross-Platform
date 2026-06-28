import '../../repository/connections_repository.dart';
import '../../entities/connections_user_entity.dart';

class GetFollowersListUseCase {
  final ConnectionsRepository repository;

  GetFollowersListUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      return await repository.getFollowersList(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }
}
