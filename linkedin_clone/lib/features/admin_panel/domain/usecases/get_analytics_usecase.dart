import '../entities/analytics_entity.dart';
import '../repositories/admin_repository.dart';

class GetUserAnalyticsUseCase {
  final AdminRepository repository;
  GetUserAnalyticsUseCase(this.repository);

  Future<UserAnalytics> call() => repository.getUserAnalytics();
}

class GetPostAnalyticsUseCase {
  final AdminRepository repository;
  GetPostAnalyticsUseCase(this.repository);

  Future<PostAnalytics> call() => repository.getPostAnalytics();
}

class GetJobAnalyticsUseCase {
  final AdminRepository repository;
  GetJobAnalyticsUseCase(this.repository);

  Future<JobAnalytics> call() => repository.getJobAnalytics();
}
