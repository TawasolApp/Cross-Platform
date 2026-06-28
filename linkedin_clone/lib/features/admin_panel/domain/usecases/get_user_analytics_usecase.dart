import '../entities/user_analytics_entity.dart';
import '../repositories/admin_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class GetUserAnalyticsUseCase {
  final AdminRepository repository;
  GetUserAnalyticsUseCase(this.repository);

  Future<Either<Failure, UserAnalytics>> call() {
    return repository.getUserAnalytics();
  }
}
