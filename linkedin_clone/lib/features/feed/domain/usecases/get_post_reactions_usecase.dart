import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';

class GetPostReactionsUseCase {
  final FeedRepository repository;

  GetPostReactionsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    String postId,
  ) async {
    return await repository.getPostReactions(postId);
  }
}
