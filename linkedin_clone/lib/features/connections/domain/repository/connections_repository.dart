import '../entities/connections_user_entity.dart';

abstract class ConnectionsRepository {
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    int page = 0,
    int limit = 0,
  });
  Future<bool> removeConnection(String userId, String? token);
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList({
    int page = 0,
    int limit = 0,
  });
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList({
    int page = 0,
    int limit = 0,
  });
  Future<bool> acceptConnectionRequest(String userId, String? token);
  Future<bool> ignoreConnectionRequest(String userId, String? token);
  Future<bool> sendConnectionRequest(String userId, String? token);
}
