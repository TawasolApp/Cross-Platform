import '../repositories/feed_repository.dart';
import '../entities/post_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class GetUserPostsUseCase {
  final FeedRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getUserPosts(userId);
  }
}
