import '../repository/connections_repository.dart';

class unblockUserUseCase {
  final ConnectionsRepository repository;

  unblockUserUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.unblockUser(userId);
  }
}
