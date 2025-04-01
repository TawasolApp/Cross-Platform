import '../entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getRecentJobs();
}
