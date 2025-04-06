// domain/usecases/get_news_feed_usecase.dart
import '../../domain/repositories/feed_repository.dart';
import '../entities/post_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class GetPostsUseCase {
  final FeedRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getPosts(page: page, limit: limit);
  }
}
