import 'package:linkedin_clone/core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSavedPostsUseCase {
  final FeedRepository repository;

  GetSavedPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call(
    String companyId, {
    int page = 1,
    int limit = 10,
  }) {
    return repository.getSavedPosts(companyId, page: page, limit: limit);
  }
}
