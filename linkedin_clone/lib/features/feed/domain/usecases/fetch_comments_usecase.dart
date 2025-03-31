import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class FetchCommentsUseCase {
  final FeedRepository repository;

  FetchCommentsUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call(
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.fetchComments(postId, page: page, limit: limit);
  }
}
