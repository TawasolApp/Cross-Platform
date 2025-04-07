import '../repositories/feed_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class EditPostUseCase {
  final FeedRepository repository;

  EditPostUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String postId,
    required String content,
    required List<String>? media,
    required List<String>? taggedUsers,
    required String visibility,
  }) {
    print('Use Case: Calling repository with post ID: $postId');
    return repository.editPost(
      postId: postId,
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
    );
  }
}
