import '../../repository/connections_repository.dart';

class UnblockUserUseCase {
  final ConnectionsRepository repository;

  UnblockUserUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.unblockUser(userId);
  }
}
