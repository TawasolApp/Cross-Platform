import 'package:linkedin_clone/features/connections/presentations/widgets/unfollow_dialog.dart';

import '../entities/connections_user_entity.dart';

abstract class ConnectionsRepository {
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    int page = 0,
    int limit = 0,
    int sortBy = 1,
  });
  Future<bool> removeConnection(String userId);
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList({
    int page = 0,
    int limit = 0,
  });
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList({
    int page = 0,
    int limit = 0,
  });
  Future<List<ConnectionsUserEntity>> getFollowingList({
    int page = 0,
    int limit = 0,
  });
  Future<List<ConnectionsUserEntity>> getFollowersList({
    int page = 0,
    int limit = 0,
  });
  Future<bool> acceptIgnoreConnectionRequest(String userId);
  Future<bool> sendConnectionRequest(String userId);
  Future<bool> withdrawConnectionRequest(String userId);
  Future<bool> unfollowUser(String userId);
}
