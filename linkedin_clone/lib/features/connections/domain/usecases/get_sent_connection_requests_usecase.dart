import '../repository/connections_repository.dart';
import '../entities/connections_user_entity.dart';

class GetSentConnectionRequestsUseCase {
  final ConnectionsRepository repository;

  GetSentConnectionRequestsUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call(String? token) async {
    return await repository.getReceivedConnectionRequestsList(token);
  }
}
