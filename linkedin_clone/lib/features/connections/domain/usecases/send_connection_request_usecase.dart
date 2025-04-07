import '../repository/connections_repository.dart';

class SendConnectionRequestUseCase {
  final ConnectionsRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<bool> call(String token, String userID) async {
    return await repository.sendConnectionRequest(userID);
  }
}
