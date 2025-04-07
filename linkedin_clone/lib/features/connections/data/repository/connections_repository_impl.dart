import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import '../datasources/connections_remote_data_source.dart';
import '../../domain/repository/connections_repository.dart';

class ConnectionsRepositoryImpl implements ConnectionsRepository {
  final ConnectionsRemoteDataSource remoteDataSource;

  ConnectionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ConnectionsUserEntity>> getConnectionsList({
    int page = 0,
    int limit = 0,
    int sortBy = 1,
  }) async {
    try {
      final connectionsList = await remoteDataSource.getConnectionsList(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
      return connectionsList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> removeConnection(String userId) async {
    try {
      bool removed = await remoteDataSource.removeConnection(userId);
      return removed;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final pendingList = await remoteDataSource
          .getReceivedConnectionRequestsList(page: page, limit: limit);
      return pendingList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ConnectionsUserEntity>> getFollowersList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final followersList = await remoteDataSource.getFollowersList(
        page: page,
        limit: limit,
      );
      return followersList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ConnectionsUserEntity>> getFollowingList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final followingList = await remoteDataSource.getFollowingList(
        page: page,
        limit: limit,
      );
      return followingList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      final sentList = await remoteDataSource.getSentConnectionRequestsList(
        page: page,
        limit: limit,
      );
      return sentList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> acceptIgnoreConnectionRequest(String userId) async {
    try {
      final accepted = await remoteDataSource.acceptIgnoreConnectionRequest(
        userId,
      );
      return accepted;
    } catch (e) {
      throw Exception('Failed to accept connection request');
    }
  }

  @override
  Future<bool> sendConnectionRequest(String userId) async {
    try {
      final sent = await remoteDataSource.sendConnectionRequest(userId);
      return sent;
    } catch (e) {
      throw Exception('Failed to send connection request');
    }
  }

  @override
  Future<bool> withdrawConnectionRequest(String userId) async {
    try {
      final withdrawn = await remoteDataSource.withdrawConnectionRequest(
        userId,
      );
      return withdrawn;
    } catch (e) {
      throw Exception('Failed to withdraw connection request');
    }
  }

  @override
  Future<bool> unfollowUser(String userId) async {
    try {
      final unfollowed = await remoteDataSource.unfollowUser(userId);
      return unfollowed;
    } catch (e) {
      throw Exception('Failed to unfollow user');
    }
  }
}
