import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class DeleteCommentUseCase {
  final FeedRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String commentId) async {
    return await repository.deleteComment(commentId);
  }
}
