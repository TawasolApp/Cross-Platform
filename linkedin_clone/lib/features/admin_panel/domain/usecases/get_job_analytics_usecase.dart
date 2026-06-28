import 'package:dartz/dartz.dart';
import '../entities/job_analytics_entity.dart';
import '../repositories/admin_repository.dart';
import '../../../../core/errors/failures.dart';

class GetJobAnalyticsUseCase {
  final AdminRepository repository;

  GetJobAnalyticsUseCase(this.repository);

  Future<Either<Failure, JobAnalytics>> call() {
    return repository.getJobAnalytics();
  }
}
