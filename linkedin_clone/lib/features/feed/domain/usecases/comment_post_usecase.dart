import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';
import '../../data/models/comment_model.dart';

class CommentPostUseCase {
  final FeedRepository repository;

  CommentPostUseCase(this.repository);

  Future<Either<Failure, CommentModel>> call(
    String userId, {
    required String postId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  }) async {
    print(
      'CommentPostUseCase called with postId: $postId, content: $content, taggedUsers: $taggedUsers, isReply: $isReply, userId: $userId',
    );

    return await repository.addComment(
      userId,
      postId: postId,
      content: content,
      taggedUsers: taggedUsers,
      isReply: isReply,
    );
  }
}
