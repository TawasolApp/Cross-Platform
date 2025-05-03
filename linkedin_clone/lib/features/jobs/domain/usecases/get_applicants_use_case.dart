import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class GetApplicantsUseCase {
  final JobRepository repository;

  GetApplicantsUseCase({required this.repository});

  Future<List<ApplicationEntity>> call(String jobId,    {int page = 1,
    int limit=5}) {
    return repository.getApplicants(jobId,page: page, limit: limit);
  }
}
