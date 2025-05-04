import 'package:linkedin_clone/features/feed/domain/repositories/feed_repository.dart';
import '../entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';

class SearchPostsUseCase {
  final FeedRepository repository;
  SearchPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    required String companyId,
    required String query,
    bool? network,
    String timeframe = 'all',
    int page = 1,
    int limit = 10,
  }) {
    print("🔗🔗🔗🔗🔗SearchPostsUseCase called with query: $query");
    return repository.searchPosts(
      companyId: companyId,
      query: query,
      network: network,
      timeframe: timeframe,
      page: page,
      limit: limit,
    );
  }
}
