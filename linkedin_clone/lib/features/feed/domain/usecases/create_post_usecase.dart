// domain/usecases/create_post_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../repositories/feed_repository.dart';
import '../entities/post_entity.dart';
import '../../../../core/errors/failures.dart';

class CreatePostUseCase {
  final FeedRepository repository;
  CreatePostUseCase(this.repository);
  Future<Either<Failure, PostEntity>> call({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    return await repository.createPost(
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
      parentPostId: parentPostId,
      isSilentRepost: isSilentRepost,
    );
  }
}
