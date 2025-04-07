import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';

import '../entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getRecentJobs(String companyId,{int page = 1, int limit = 4});
  Future<bool> addJob(CreateJobEntity job,String companyId);
}
