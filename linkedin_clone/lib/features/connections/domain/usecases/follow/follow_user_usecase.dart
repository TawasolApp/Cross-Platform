import '../../repository/connections_repository.dart';

class FollowUserUseCase {
  final ConnectionsRepository repository;

  FollowUserUseCase(this.repository);
  Future<bool> call(String userId) async {
    return await repository.followUser(userId);
  }
}
