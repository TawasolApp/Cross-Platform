import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class GetJobByIdUseCase {
  final JobRepository repository;

  GetJobByIdUseCase(this.repository);

  Future<Job> call(String jobId) {
    return repository.getJobById(jobId);
  }
}
