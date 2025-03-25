import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class DeletePostUseCase {
  final FeedRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId) {
    return repository.deletePost(postId);
  }
}
