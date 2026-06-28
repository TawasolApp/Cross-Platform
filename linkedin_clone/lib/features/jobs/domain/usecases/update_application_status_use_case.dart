import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class UpdateApplicationStatusUseCase {
  final JobRepository repository;

  UpdateApplicationStatusUseCase({required this.repository});

  Future<bool> call(String applicationId, String newStatus) {
    return repository.updateApplicationStatus(applicationId, newStatus);
  }
}