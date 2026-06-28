import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class CreateJob {
  final JobRepository repository;

  CreateJob({required this.repository});

  Future<void> execute(CreateJobEntity job, String companyId) async {
    // Validate the input fields to ensure no empty fields
    if (job.position.isEmpty ||
        job.location.isEmpty ||
        job.locationType.isEmpty ||
        job.employmentType.isEmpty) {
      throw Exception("Missing Fields are required.");
    }

    try {
      // Call the remote data source to add the job
      final success = await repository.addJob(job, companyId);

      if (!success) {
        throw Exception("Failed to add job.");
      }
    } catch (e) {
      // Handle any error that occurs during the add job process
      print("Error adding job: $e");
      rethrow;
    }
  }
}
