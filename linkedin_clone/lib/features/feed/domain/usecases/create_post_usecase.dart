import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, PostEntity>> call({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) {
    return repository.createPost(
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
    );
  }
}
