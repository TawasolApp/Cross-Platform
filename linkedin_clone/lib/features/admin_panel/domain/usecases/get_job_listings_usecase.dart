import '../entities/job_listing_entity.dart';
import '../repositories/admin_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../jobs/domain/entities/job_entity.dart';

class GetJobListingsUseCase {
  final AdminRepository repository;

  GetJobListingsUseCase(this.repository);

  Future<Either<Failure, List<Job>>> call({
    required int page,
    required int limit,
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
  }) {
    return repository.getJobListings(
      page: page,
      limit: limit,
      keyword: keyword,
      location: location,
      industry: industry,
      experienceLevel: experienceLevel,
      company: company,
      minSalary: minSalary,
      maxSalary: maxSalary,
    );
  }
}
