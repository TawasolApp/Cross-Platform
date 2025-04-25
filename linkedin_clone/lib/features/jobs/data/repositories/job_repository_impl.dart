import 'package:linkedin_clone/features/jobs/data/model/create_job_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';

import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job.dart';
import 'package:linkedin_clone/features/jobs/data/datasource/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Job>> getRecentJobs(String companyId,{int page = 1, int limit = 4}) async {
    List<Job> jobs = await remoteDataSource.getRecentJobs(companyId,page: page,limit: limit);
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
