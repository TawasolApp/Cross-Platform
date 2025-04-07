import '../repository/connections_repository.dart';

class UnfollowUserUseCase {
  final ConnectionsRepository repository;

  UnfollowUserUseCase(this.repository);
  Future<bool> call(String userId) async {
    return await repository.unfollowUser(userId);
  }
}

class UnfollowUserParams {
  final String userId;

  UnfollowUserParams({required this.userId});
}
