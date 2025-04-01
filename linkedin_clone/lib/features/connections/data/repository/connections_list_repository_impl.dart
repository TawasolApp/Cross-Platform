import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';
import '../datasources/connections_remote_data_source.dart';
import '../../domain/repository/connections_list_repository.dart';

class ConnectionsListRepositoryImpl implements ConnectionsListRepository {
  final ConnectionsRemoteDataSource remoteDataSource;

  ConnectionsListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ConnectionsListUserEntity>> getConnectionsList(
    String? token,
  ) async {
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
}
