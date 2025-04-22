import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';
import '../../data/models/reaction_model.dart';

class GetPostReactionsUseCase {
  final FeedRepository repository;

  GetPostReactionsUseCase(this.repository);

  Future<Either<Failure, List<ReactionModel>>> call(
    String userId,
    String postId, {
    String type = 'All',
  }) async {
    return await repository.getPostReactions(userId, postId, type: type);
  }
}
