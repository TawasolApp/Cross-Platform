import '../../domain/repository/connections_list_repository.dart';

class RemoveConnectionUseCase {
  final ConnectionsListRepository repository;

  RemoveConnectionUseCase(this.repository);

  Future<bool> call(String userId, String? token) async {
    return await repository.removeConnection(userId, token);
  }
}
