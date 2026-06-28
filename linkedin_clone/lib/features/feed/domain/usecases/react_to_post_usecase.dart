import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class ReactToPostUseCase {
  final FeedRepository repository;

  ReactToPostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
    String userId, {
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    return await repository.reactToPost(
      userId,
      postId: postId,
      reactions: reactions,
      postType: postType,
    );
  }
}
