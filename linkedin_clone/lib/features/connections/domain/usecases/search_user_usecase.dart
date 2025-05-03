import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/repository/connections_repository.dart';

class SearchUserUsecase {
  final ConnectionsRepository repository;

  SearchUserUsecase(this.repository);
  Future<List<ConnectionsUserEntity>> call({
    String? searchWord,
    int page = 0,
    int limit = 0,
  }) async {
    try {
      print('🤩🤩🤩🤩Search word: $searchWord');
      return await repository.performSearch(
        searchWord: searchWord,
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }
}
