import '../repositories/admin_repository.dart';

class DeleteJobListingUseCase {
  final AdminRepository repository;

  DeleteJobListingUseCase(this.repository);

  Future<void> call(String jobId) {
    return repository.deleteJobListing(jobId);
  }
}
