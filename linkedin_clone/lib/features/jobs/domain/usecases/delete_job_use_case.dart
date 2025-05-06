import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class DeleteJob {
  final JobRepository repository;

  DeleteJob(this.repository);

  Future<bool> call(String jobId) {
    return repository.deleteJob(jobId);
  }
}
