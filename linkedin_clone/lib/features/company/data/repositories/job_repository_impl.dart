import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';

import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job.dart';
import 'package:linkedin_clone/features/company/data/datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Job>> getRecentJobs() async {
    return await remoteDataSource.getRecentJobs();
  }
  @override
  Future<void> addJob(CreateJobEntity job) async {
    await remoteDataSource.addJob(job);
  }
}
