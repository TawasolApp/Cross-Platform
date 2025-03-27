import '../../domain/repository/connections_list_repository.dart';
import '../entities/connections_list_user_entity.dart';

class GetConnectionsUseCase {
  final ConnectionsListRepository repository;

  GetConnectionsUseCase(this.repository);

  Future<List<ConnectionsListUserEntity>> call(String? token) async {
    return await repository.getConnectionsList(token);
  }
}
