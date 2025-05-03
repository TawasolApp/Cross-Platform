import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';

import '../entities/connections_user_entity.dart';

abstract class ConnectionsRepository {
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    String? userId,
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
  Future<bool> acceptIgnoreConnectionRequest(String userId, bool accept);
  Future<bool> sendConnectionRequest(String userId);
  Future<bool> withdrawConnectionRequest(String userId);
  Future<bool> unfollowUser(String userId);
  Future<bool> followUser(String userId);

  Future<List<PeopleYouMayKnowUserEntity>> getPeopleYouMayKnowList({
    int page = 0,
    int limit = 0,
  });

  Future<bool> endorseSkill(String userId, String skillName);
  Future<bool> removeEndorsement(String userId, String skillName);

  Future<int> getFollowersCount();
  Future<int> getFollowingsCount();
  Future<List<ConnectionsUserEntity>> performSearch({
    String? searchWord,
    int page = 0,
    int limit = 0,
  });
}
