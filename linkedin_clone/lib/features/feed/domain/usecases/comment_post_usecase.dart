import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class CommentPostUseCase {
  final FeedRepository repository;

  CommentPostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String postId, String content) async {
    return await repository.addComment(postId, content);
  }
}
