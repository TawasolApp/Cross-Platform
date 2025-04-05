import 'package:linkedin_clone/features/company/data/models/create_job_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';

import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job.dart';
import 'package:linkedin_clone/features/company/data/datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Job>> getRecentJobs(String companyId) async {
    List<Job> jobs = await remoteDataSource.getRecentJobs(companyId);
    print('Jobs at repository: ${jobs}');
    return jobs;
  }

  @override
  Future<bool> addJob(CreateJobEntity job, String companyId) async {
   return await remoteDataSource.addJob(
      CreateJobModel(
        position: job.position,
        industry: job.industry,
        description: job.description,
        location: job.location,
        salary: job.salary,
        experienceLevel: job.experienceLevel,
        locationType: job.locationType,
        employmentType: job.employmentType,
      ),
      companyId,
    );
  }
}
