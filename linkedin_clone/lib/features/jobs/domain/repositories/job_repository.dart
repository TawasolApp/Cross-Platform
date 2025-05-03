import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';

import '../entities/job_entity.dart';

abstract class JobRepository {
  Future<List<Job>> getRecentJobs(
    String companyId, {
    int page = 1,
    int limit = 4,
  });
  Future<bool> addJob(CreateJobEntity job, String companyId);
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
  });
  Future<bool> deleteJob(String jobId);
  Future<bool> applyForJob(ApplyForJobEntity application);
  Future<List<ApplicationEntity>> getApplicants(
    String jobId, {
    int page = 1,
    int limit = 5,
  });
  // Future<List<Job>> getSavedJobs(String userId,{int page = 1, int limit = 4});
  Future<bool> updateApplicationStatus(String applicationId, String newStatus);
Future<bool> saveJob(String jobId);
Future<bool> unsaveJob(String jobId);
}
