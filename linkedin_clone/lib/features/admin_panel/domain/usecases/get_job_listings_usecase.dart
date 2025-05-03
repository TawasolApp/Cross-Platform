import '../entities/job_listing_entity.dart';
import '../repositories/admin_repository.dart';

class GetJobListingsUseCase {
  final AdminRepository repository;

  GetJobListingsUseCase(this.repository);

  Future<List<JobListingEntity>> call() {
    return repository.getFlaggedJobs();
  }
}
