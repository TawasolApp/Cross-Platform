import '../entities/connections_user_entity.dart';

abstract class ConnectionsRepository {
  Future<List<ConnectionsUserEntity>> getConnectionsList(String? token);
  Future<bool> removeConnection(String userId, String? token);
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList(
    String? token,
  );
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList(
    String? token,
  );
  Future<bool> acceptConnectionRequest(String userId, String? token);
  Future<bool> ignoreConnectionRequest(String userId, String? token);
  Future<bool> sendConnectionRequest(String userId, String? token);
}
