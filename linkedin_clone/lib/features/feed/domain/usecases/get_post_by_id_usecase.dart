import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class FetchPostByIdUseCase {
  final FeedRepository repository;

  FetchPostByIdUseCase(this.repository);

  Future<Either<Failure, PostEntity>> call({
    required String userId,
    required String postId,
  }) {
    return repository.fetchPostById(userId: userId, postId: postId);
  }
}
