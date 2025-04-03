import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';

import '../entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getRecentJobs();
  Future<void> addJob(CreateJobEntity job);
}
