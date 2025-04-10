import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/features/feed/data/models/comment_model.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class FetchCommentsUseCase {
  final FeedRepository repository;

  FetchCommentsUseCase(this.repository);

  Future<Either<Failure, List<CommentModel>>> call(
    String postId, {
    int page = 1,
    int limit = 10,
  }) {
    return repository.fetchComments(postId, page: page, limit: limit);
  }
}
