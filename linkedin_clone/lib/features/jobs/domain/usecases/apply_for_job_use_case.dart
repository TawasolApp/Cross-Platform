import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class ApplyForJobUseCase {
  final JobRepository repository;

  ApplyForJobUseCase({required this.repository});

  Future<bool> call(ApplyForJobEntity application) {
    return repository.applyForJob(application);
  }
}