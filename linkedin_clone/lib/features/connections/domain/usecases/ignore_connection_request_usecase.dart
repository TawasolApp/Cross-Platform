import '../repository/connections_repository.dart';

class IgnoreConnectionRequestUseCase {
  final ConnectionsRepository repository;

  IgnoreConnectionRequestUseCase(this.repository);

  Future<bool> call(String connectionId, String token) async {
    return await repository.ignoreConnectionRequest(token, connectionId);
  }
}
