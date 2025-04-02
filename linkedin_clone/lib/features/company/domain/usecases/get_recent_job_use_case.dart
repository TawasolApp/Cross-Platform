import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetRecentJobs {
  final JobRepository repository;

  GetRecentJobs({required this.repository});

  Future<List<Job>> execute() async {
    return await repository.getRecentJobs();
  }
}
