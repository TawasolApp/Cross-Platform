import '../../domain/repositories/feed_repository.dart';
import '../entities/post_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class GetRepostsUseCase {
  final FeedRepository repository;

  GetRepostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    required String userId,
    required String postId,
    int page = 1,
    int limit = 10,
  }) {
    return repository.getReposts(
      userId: userId,
      postId: postId,
      page: page,
      limit: limit,
    );
  }
}
