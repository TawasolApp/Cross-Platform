import 'package:dartz/dartz.dart';
import '../entities/post_analytics_entity.dart';
import '../repositories/admin_repository.dart';
import '../../../../core/errors/failures.dart';

class GetPostAnalyticsUseCase {
  final AdminRepository repository;

  GetPostAnalyticsUseCase(this.repository);

  Future<Either<Failure, PostAnalytics>> call() {
    return repository.getPostAnalytics();
  }
}
