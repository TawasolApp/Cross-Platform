import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class SavePostUseCase {
  final FeedRepository repository;

  SavePostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String userId, String postId) {
    return repository.savePost(userId, postId);
  }
}
