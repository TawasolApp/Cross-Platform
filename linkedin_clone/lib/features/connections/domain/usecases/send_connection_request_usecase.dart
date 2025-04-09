import '../repository/connections_repository.dart';

class SendConnectionRequestUseCase {
  final ConnectionsRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<bool> call(String userID) async {
    try {
      return await repository.sendConnectionRequest(userID);
    } catch (e) {
      rethrow;
    }
  }
}
