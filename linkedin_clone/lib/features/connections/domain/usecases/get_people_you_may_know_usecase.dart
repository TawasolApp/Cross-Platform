import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/repository/connections_repository.dart';

class GetPeopleYouMayKnowUseCase {
  final ConnectionsRepository repository;

  GetPeopleYouMayKnowUseCase(this.repository);

  Future<List<PeopleYouMayKnowUserEntity>> call({
    int page = 0,
    int limit = 0,
  }) async {
    try {
      return await repository.getPeopleYouMayKnowList(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }
}
