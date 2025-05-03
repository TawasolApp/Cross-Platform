import '../repositories/admin_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class DeleteJobListingUseCase {
  final AdminRepository repository;

  DeleteJobListingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String jobId) {
    return repository.deleteJobListing(jobId);
  }
}
