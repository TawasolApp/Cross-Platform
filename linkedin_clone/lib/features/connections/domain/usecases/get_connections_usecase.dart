import '../repository/connections_repository.dart';
import '../entities/connections_user_entity.dart';

class GetConnectionsUseCase {
  final ConnectionsRepository repository;

  GetConnectionsUseCase(this.repository);

  Future<List<ConnectionsUserEntity>> call(String? token) async {
    try {
      return await repository.getConnectionsList(token);
    } catch (e) {
      rethrow;
    }
  }
}
