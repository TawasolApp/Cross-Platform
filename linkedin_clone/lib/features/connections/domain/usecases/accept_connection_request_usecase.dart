import '../repository/connections_repository.dart';

class AcceptConnectionRequestUseCase {
  final ConnectionsRepository repository;

  AcceptConnectionRequestUseCase(this.repository);

  Future<bool> call(String token, String connectionId) async {
    return await repository.acceptConnectionRequest(token, connectionId);
  }
}
