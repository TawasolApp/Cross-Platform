import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/feed_repository.dart';
import '../../data/models/reaction_model.dart';

class GetPostReactionsUseCase {
  final FeedRepository repository;

  GetPostReactionsUseCase(this.repository);

  Future<Either<Failure, List<ReactionModel>>> call(
    String postId, {
    String type = 'All',
  }) async {
    return await repository.getPostReactions(postId, type: type);
  }
}
