import 'package:linkedin_clone/features/jobs/data/model/create_job_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';

import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job_entity.dart';
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

@override
Future<List<Job>> searchJobs({
  String? keyword,
  String? location,
  String? industry,
  String? experienceLevel,
  String? company,
  double? minSalary,
  double? maxSalary,
  int page = 1,
  int limit = 5,
}) {
  return remoteDataSource.searchJobs(
    keyword: keyword,
    location: location,
    industry: industry,
    experienceLevel: experienceLevel,
    company: company,
    minSalary: minSalary,
    maxSalary: maxSalary,
    page: page,
    limit: limit,
  );
}

@override
Future<bool> deleteJob(String jobId) {
  return remoteDataSource.deleteJob(jobId);
}

@override
Future<bool> applyForJob(ApplyForJobEntity application) {
  return remoteDataSource.applyForJob(application);
}
@override
Future<List<ApplicationEntity>> getApplicants(String jobId,{int page = 1, int limit = 5}) {
  return remoteDataSource.getApplicants(jobId,page: page, limit: limit);
}
@override
Future<bool> updateApplicationStatus(String applicationId, String newStatus) {
  return remoteDataSource.updateApplicationStatus(applicationId, newStatus);
}
@override
Future<bool> saveJob(String jobId) {
  return remoteDataSource.saveJob(jobId);
}

@override
Future<bool> unsaveJob(String jobId) {
  return remoteDataSource.unsaveJob(jobId);
}

}
