import '../../repository/connections_repository.dart';

class GetFollowingsCountUsecase {
  final ConnectionsRepository repository;

  GetFollowingsCountUsecase(this.repository);
  Future<int> call() async {
    return await repository.getFollowingsCount();
  }
}
