import '../repository/connections_repository.dart';
import '../entities/connections_user_entity.dart';

class GetReceivedConnectionRequestsUseCase {
  final ConnectionsRepository repository;

  GetReceivedConnectionRequestsUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call(String? token) async {
    try {
      return await repository.getReceivedConnectionRequestsList(token);
    } catch (e) {
      rethrow;
    }
  }
}
