import '../entities/connections_list_user_entity.dart';

abstract class ConnectionsListRepository {
  Future<List<ConnectionsListUserEntity>> getConnectionsList();
  Future<bool> removeConnection(String userId);
}
