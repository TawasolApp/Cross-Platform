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
  Future<bool> removeConnection(String userId, String? token) async {
    try {
      bool removed = await remoteDataSource.removeConnection(userId, token);
      return removed;
    } catch (e) {
      throw Exception('Failed to remove connection');
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
  Future<bool> acceptConnectionRequest(String userId, String? token) async {
    try {
      final accepted = await remoteDataSource.acceptConnectionRequest(
        userId,
        token,
      );
      return accepted;
    } catch (e) {
      throw Exception('Failed to accept connection request');
    }
  }

  @override
  Future<bool> ignoreConnectionRequest(String userId, String? token) async {
    try {
      final ignored = await remoteDataSource.ignoreConnectionRequest(
        userId,
        token,
      );
      return ignored;
    } catch (e) {
      throw Exception('Failed to ignore connection request');
    }
  }

  @override
  Future<bool> sendConnectionRequest(String userId, String? token) async {
    try {
      final sent = await remoteDataSource.sendConnectionRequest(userId, token);
      return sent;
    } catch (e) {
      throw Exception('Failed to send connection request');
    }
  }
}
