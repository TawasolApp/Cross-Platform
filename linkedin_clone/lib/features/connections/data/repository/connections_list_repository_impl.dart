import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';
import '../datasources/connections_remote_data_source.dart';
import '../../domain/repository/connections_list_repository.dart';

class ConnectionsListRepositoryImpl implements ConnectionsListRepository {
  final ConnectionsRemoteDataSource remoteDataSource;

  ConnectionsListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ConnectionsListUserEntity>> getConnectionsList() async {
    try {
      final connectionsList = await remoteDataSource.getConnectionsList();
      return connectionsList;
    } catch (e) {
      print(e); //for debugging
      throw Exception('Failed to load connections list');
    }
  }

  @override
  Future<bool> removeConnection(String userId) async {
    try {
      bool removed = await remoteDataSource.removeConnection(userId);
      return removed;
    } catch (e) {
      print(e); //for debugging
      throw Exception('Failed to remove connection');
    }
  }
}
