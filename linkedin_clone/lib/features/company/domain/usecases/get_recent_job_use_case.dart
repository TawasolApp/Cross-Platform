import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetRecentJobs {
  final JobRepository repository;

  GetRecentJobs({required this.repository});

  Future<List<Job>> execute(String companyId) async {
     List<Job> jobs = await repository.getRecentJobs(companyId);
     print('Jobs at use case: ${jobs}');
      return jobs;
  }
}
