import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class UnsavePostUseCase {
  final FeedRepository repository;

  UnsavePostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String userId, String postId) {
    print("Use Case: Calling repository to unsave post with ID: $postId");
    return repository.unsavePost(userId, postId);
  }
}
