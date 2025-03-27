import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class UpdateCertificationUseCase implements UseCase<void, Certification> {
  final ProfileRepository repository;

  UpdateCertificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Certification certification) {
    return repository.updateCertification(certification);
  }
}