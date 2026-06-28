import '../../repository/connections_repository.dart';

class GetFollowersCountUsecase {
  final ConnectionsRepository repository;

  GetFollowersCountUsecase(this.repository);
  Future<int> call() async {
    return await repository.getFollowersCount();
  }
}
