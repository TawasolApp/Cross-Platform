import '../entities/job_entity.dart';
import '../repositories/job_repository.dart';

class SearchJobs {
  final JobRepository repository;

  SearchJobs(this.repository);

  Future<List<Job>> call({
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
    int page = 1,
    int limit=5,
  }) {
    return repository.searchJobs(
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
}
