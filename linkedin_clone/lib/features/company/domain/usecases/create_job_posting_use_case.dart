import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';
import 'package:linkedin_clone/features/company/domain/repositories/job_repository.dart';

class CreateJob {
  final JobRepository repository;

  CreateJob({required this.repository});

  Future<void> execute(CreateJobEntity job) async {
    // Validate the input fields
    if (job.position.isEmpty || job.location.isEmpty|| job.locationType.isEmpty||job.employmentType.isEmpty) {
      throw Exception("Missing Fields are required.");
    }

    // Call the remote data source to add the job
    return await repository.addJob(job);
  }
}
