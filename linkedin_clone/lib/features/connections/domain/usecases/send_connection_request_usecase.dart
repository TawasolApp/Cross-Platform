import '../repository/connections_repository.dart';

class SendConnectionRequestUseCase {
  final ConnectionsRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<bool> call(String token, String connectionId) async {
    return await repository.sendConnectionRequest(token, connectionId);
  }
}
