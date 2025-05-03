import '../../repository/connections_repository.dart';

class RemoveEndorsementUsecase {
  final ConnectionsRepository repository;

  RemoveEndorsementUsecase(this.repository);

  Future<bool> call(String userId, String skillId) async {
    return await repository.removeEndorsement(userId, skillId);
  }
}
