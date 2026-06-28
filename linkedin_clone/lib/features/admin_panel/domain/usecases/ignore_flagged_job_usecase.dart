import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class IgnoreFlaggedJobUseCase {
  final AdminRepository repository;

  IgnoreFlaggedJobUseCase(this.repository);

  Future<Either<Failure, String>> call(String jobId) {
    return repository.ignoreFlaggedJob(jobId);
  }
}
