import '../repository/connections_repository.dart';

class BlockUserUseCase {
  final ConnectionsRepository repository;

  BlockUserUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.blockUser(userId);
  }
}
