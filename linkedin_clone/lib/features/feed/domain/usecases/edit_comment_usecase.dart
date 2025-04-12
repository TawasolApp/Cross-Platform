import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class EditCommentUseCase {
  final FeedRepository repository;

  EditCommentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String commentId,
    required String content,
    List<String>? tagged,
    bool isReply = false,
  }) async {
    return await repository.editComment(
      commentId: commentId,
      content: content,
      tagged: tagged,
      isReply: isReply,
    );
  }
}
