import '../repository/connections_repository.dart';

class AcceptIgnoreConnectionRequestUseCase {
  final ConnectionsRepository repository;

  AcceptIgnoreConnectionRequestUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.acceptIgnoreConnectionRequest(userId);
  }
}
