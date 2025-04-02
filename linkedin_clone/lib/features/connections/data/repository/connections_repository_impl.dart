import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import '../datasources/connections_remote_data_source.dart';
import '../../domain/repository/connections_repository.dart';

class ConnectionsRepositoryImpl implements ConnectionsRepository {
  final ConnectionsRemoteDataSource remoteDataSource;

  ConnectionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ConnectionsUserEntity>> getConnectionsList(String? token) async {
    try {
      final connectionsList = await remoteDataSource.getConnectionsList(token);
      return connectionsList;
    } catch (e) {
      throw Exception('no connection');
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
  Future<List<ConnectionsUserEntity>> getReceivedConnectionRequestsList(
    String? token,
  ) async {
    try {
      final pendingList = await remoteDataSource
          .getReceivedConnectionRequestsList(token);
      if (pendingList.isEmpty) {
        throw Exception('No pending connection requests found');
      }
      return pendingList;
    } catch (e) {
      throw Exception('no connection');
    }
  }

  @override
  Future<List<ConnectionsUserEntity>> getSentConnectionRequestsList(
    String? token,
  ) async {
    try {
      final sentList = await remoteDataSource.getSentConnectionRequestsList(
        token,
      );
      if (sentList.isEmpty) {
        throw Exception('No sent connection requests found');
      }
      return sentList;
    } catch (e) {
      throw Exception('no connection');
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
}
