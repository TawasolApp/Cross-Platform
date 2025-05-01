import '../repositories/job_repository.dart';

class SaveJobUseCase{
  final JobRepository repository;

  SaveJobUseCase({required this.repository});

  Future<bool> call(String jobId) {
    return repository.saveJob(jobId);
  }
}