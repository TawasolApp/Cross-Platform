import '../repositories/job_repository.dart';
  
  
  class UnsaveJobUseCase {
  final JobRepository repository;

  UnsaveJobUseCase({required this.repository});

  Future<bool> call(String jobId) {
    return repository.unsaveJob(jobId);
  }
}
