// domain/usecases/get_news_feed_usecase.dart
import '../../domain/repositories/feed_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class GetNewsFeedUseCase {
  final FeedRepository feedRepository;

  GetNewsFeedUseCase(this.feedRepository);

  Future<Either<Failure, List<PostEntity>>> execute({
    required int page,
    required int limit,
  }) {
    return feedRepository.getPosts(page: page, limit: limit);
  }
}
