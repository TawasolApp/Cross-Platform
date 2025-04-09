import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetRecentJobs {
  final JobRepository repository;

  GetRecentJobs({required this.repository});

  Future<List<Job>> execute(String companyId,{int page = 1, int limit = 4}) async {
     List<Job> jobs = await repository.getRecentJobs(companyId,page: page, limit: limit);
     print('Jobs at use case: ${jobs}');
      return jobs;
  }
}
