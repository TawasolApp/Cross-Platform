import '../repository/connections_repository.dart';

class RemoveConnectionUseCase {
  final ConnectionsRepository repository;

  RemoveConnectionUseCase(this.repository);

  Future<bool> call(String userId) async {
    try {
      return await repository.removeConnection(userId);
    } catch (e) {
      rethrow;
    }
  }
}
